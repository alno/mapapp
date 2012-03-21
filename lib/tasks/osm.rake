require 'fileutils'

namespace :osm do

  desc "Prepare hillshade data"
  task :hillshade do
    if File.exists? Rails.root.join('..', '..', 'shared')
      heightdir = Rails.root.join('..', '..', 'shared', 'heights')
    else
      heightdir = Rails.root.join('..', 'heights')
    end

    min_lat = 52
    max_lat = 56
    min_lon = 31
    max_lon = 38

    puts "Downloading height data..."

    names = (min_lat..max_lat).map{|lat| (min_lon..max_lon).map{|lon| "N#{lat}E0#{lon}" } }.flatten
    names.each do |name|
      `cd '#{heightdir}' && wget http://dds.cr.usgs.gov/srtm/version2_1/SRTM3/Eurasia/#{name}.hgt.zip` unless File.exists? heightdir.join("#{name}.hgt.zip")
      `cd '#{heightdir}' && yes | '#{Rails.root.join('vendor', 'bin', 'srtm_generate_hdr')}' #{name}.hgt.zip` unless File.exists? heightdir.join("#{name}.tif")
    end

    puts "Merging height data..."
    system "cd '#{heightdir}' && rm -rf all.tif && gdal_merge.py -v -o all.tif -ul_lr #{min_lon} #{max_lat} #{max_lon} #{min_lat} #{names.map{|n|"#{n}.tif"}.join(' ')}" or raise StandardError.new("Error merging data")

    puts "Reprojecting height data..."
    system "cd '#{heightdir}' && rm -rf warped.tif && gdalwarp -of GTiff -co 'TILED=YES' -srcnodata 32767 -t_srs '+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m' -rcs -order 3 -tr 30 30 -multi all.tif warped.tif" or raise StandardError.new("Error reprojecting data")

    puts "Generating hillshades..."
    system "cd '#{heightdir}' && rm -rf hillshade.tif && '#{Rails.root.join('vendor', 'bin', 'hillshade')}' warped.tif hillshade.tif -z 16" or raise StandardError.new("Error generating hillshade")

    puts "Success!"
  end

  desc "Import latest osm dump"
  task :import do
    ENV['DB_CONFIG'] ||= Rails.root.join('config', 'database.yml')

    url = "http://data.gis-lab.info/osm_dump/dump/latest/RU-KLU.osm.pbf"
    name = url.split('/').last
    db = YAML.load(File.open ENV['DB_CONFIG'])[Rails.env]

    puts "Starting import of OSM dump from '#{url}' to database '#{db.inspect}'"

    importdir = Rails.root.join('tmp', 'import')

    FileUtils.rm_rf importdir
    FileUtils.mkdir importdir

    puts "Downloading OSM dump..."

    system "cd '#{importdir}' && wget '#{url}'" or raise StandardError.new("Error downloading dump from '#{url}'")

    puts "Importing OSM dump..."

    system "cd '#{importdir}' && imposm --read --write --optimize --deploy-production-tables -m '#{Rails.root.join('config', 'mapping.py')}' -d '#{db['database']}' '#{name}'" or raise StandardError.new("Error importing data")

    puts "Success!"
  end

  desc "Render map"
  task :render do
    ENV['DB_CONFIG'] ||= Rails.root.join('config', 'database.yml')

    db = YAML.load(File.open ENV['DB_CONFIG'])[Rails.env]
    tmpdir = Rails.root.join('tmp', 'render')

    FileUtils.rm_rf tmpdir
    FileUtils.mkdir tmpdir

    puts "Preparing mapnik style..."

    xml = File.read(Rails.root.join('config', 'map.xml'))
    xml.gsub! "<Parameter name=\"dbname\"><![CDATA[gis]]></Parameter>","<Parameter name=\"dbname\"><![CDATA[#{db['database']}]]></Parameter>"
    xml.gsub! "<Parameter name=\"user\"><![CDATA[gis]]></Parameter>","<Parameter name=\"user\"><![CDATA[#{db['username']}]]></Parameter>"
    xml.gsub! "<Parameter name=\"password\"><![CDATA[gis]]></Parameter>","<Parameter name=\"password\"><![CDATA[#{db['password']}]]></Parameter>"

    File.open "#{tmpdir}/map.xml", "w" do |f|
      f.write xml
    end

    FileUtils.ln_s Rails.root.join('public', 'markers'), tmpdir.join('markers')

    puts "Loading mapnik style..."

    require 'ruby_mapnik'

    map = Mapnik::Map.from_file "#{tmpdir}/map.xml"

    puts "Rendering..."

    minx = 614
    maxx = 615
    miny = 325
    maxy = 326

    (10..18).each do |z|
      puts "Startinx zoom: #{[z, minx, miny, maxx, maxy].inspect}"

      (minx..maxx).each do |x|
        FileUtils.mkdir_p "#{tmpdir}/tiles/#{z}/#{x}"
        (miny..maxy).each do |y|
          Mapnik::Tile.new(z,x,y).render(map, "#{tmpdir}/tiles/#{z}/#{x}/#{y}.png", "png256")
        end
      end

      minx = minx * 2
      miny = miny * 2
      maxx = maxx * 2 + 1
      maxy = maxy * 2 + 1
    end

    puts "Moving tiles..."

    dir = Rails.root.join('public', 'tiles')
    FileUtils.rm_rf dir
    FileUtils.move "#{tmpdir}/tiles", dir

    puts "Success!"
  end

end
