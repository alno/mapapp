require 'fileutils'

namespace :osm do

  desc "Prepare hillshade data"
  task :hillshade do
    if File.exists? Rails.root.join('..', '..', 'shared')
      heightdir = Rails.root.join('..', '..', 'shared', 'heights')
    else
      heightdir = Rails.root.join('tmp', 'heights')
    end

    min_lat = 53
    max_lat = 56
    min_lon = 33
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

  desc "Import latest osm map"
  task :import do
    require 'osm_import'

    ENV['DB_CONFIG'] ||= Rails.root.join('config', 'database.yml')

    db = YAML.load(File.open ENV['DB_CONFIG'])[Rails.env]

    importdir = Rails.root.join('tmp', 'import')
    FileUtils.rm_rf importdir
    FileUtils.mkdir importdir

    if ENV['FILE'] # Dump is present, just import it
      dump_file = File.expand_path(ENV['FILE'])
    else # Dump should be downloaded
      dump_url = "http://data.gis-lab.info/osm_dump/dump/latest/RU-KLU.osm.pbf"
      dump_file = importdir.join(dump_url.split('/').last)

      puts "Downloading OSM dump..."
      system "cd '#{importdir}' && wget '#{dump_url}'" or raise StandardError.new("Error downloading dump from '#{dump_url}'")
    end

    unless ENV['RAW']
      puts "Importing osm data..."
      ENV['PGPASS'] = db['password']
      system "cd '#{importdir}' && '#{Rails.root.join('vendor', 'bin', 'osm2pgsql')}' -e 1-18 -o expire.list -x -j -l -G -S #{Rails.root.join('config', 'osm2pgsql.style')} -U #{db['username']} -d #{db['database']} -H #{db['host']} -p raw_osm '#{dump_file}'" or raise StandardError.new("Error importing data")
    end

    puts "Converting osm data"

    OsmImport.import 'config/mapping.rb', :dbname => db['database'], :user => db['username'], :password => db['password'], :host => db['host']

    puts "Success!"
  end

  desc "Render map"
  task :render do
    db_conf_file = ENV['DB_CONFIG'] || Rails.root.join('config', 'database.yml')
    db = YAML.load(File.open db_conf_file)[Rails.env]

    if File.exists? Rails.root.join('..', '..', 'shared')
      heightdir = Rails.root.join('..', '..', 'shared', 'heights')
      tiledir = Rails.root.join('..', '..', 'shared', 'tiles')
    else
      heightdir = Rails.root.join('tmp', 'heights')
      tiledir = Rails.root.join('public', 'tiles')
    end

    tmpdir = Rails.root.join('tmp', 'render')
    FileUtils.rm_rf tmpdir
    FileUtils.mkdir tmpdir

    puts "Preparing mapnik style..."

    xml = File.read(Rails.root.join('config', 'map.xml'))
    xml.gsub! "<Parameter name=\"dbname\"><![CDATA[gis]]></Parameter>","<Parameter name=\"dbname\"><![CDATA[#{db['database']}]]></Parameter>"
    xml.gsub! "<Parameter name=\"user\"><![CDATA[gis]]></Parameter>","<Parameter name=\"user\"><![CDATA[#{db['username']}]]></Parameter>"
    xml.gsub! "<Parameter name=\"password\"><![CDATA[zsedcft]]></Parameter>","<Parameter name=\"password\"><![CDATA[#{db['password']}]]></Parameter>"
    xml.gsub! /CDATA\[[^\]]+hillshade.tif\]/, "CDATA[hillshade.tif]"

    File.open "#{tmpdir}/map.xml", "w" do |f|
      f.write xml
    end

    FileUtils.ln_s heightdir.join('hillshade.tif'), tmpdir.join('hillshade.tif')
    FileUtils.ln_s Rails.root.join('public', 'markers'), tmpdir.join('markers')
    FileUtils.mkdir_p tiledir

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

      puts "Moving zoom..."

      FileUtils.rm_rf "#{tiledir}/#{z}"
      FileUtils.move "#{tmpdir}/tiles/#{z}", "#{tiledir}/#{z}"

      minx = minx * 2
      miny = miny * 2
      maxx = maxx * 2 + 1
      maxy = maxy * 2 + 1
    end

    puts "Success!"
  end

  desc "Import new version of map and rerender it"
  task :update => [:import, :render] do
    puts "Ok, map updated!"
  end

end
