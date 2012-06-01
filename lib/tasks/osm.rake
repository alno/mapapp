require 'fileutils'

namespace :osm do

  desc "Prepare hillshade data"
  task :hillshade do
    app_conf_file = ENV['APP_CONFIG'] || Rails.root.join('config', 'mapapp.yml')
    app = YAML.load(File.open app_conf_file)[Rails.env]

    if File.exists? Rails.root.join('..', '..', 'shared')
      heightdir = Rails.root.join('..', '..', 'shared', 'heights')
    else
      heightdir = Rails.root.join('tmp', 'heights')
    end

    min_lat = app['map']['bbox']['min_lat'].to_f.floor
    max_lat = app['map']['bbox']['max_lat'].to_f.ceil
    min_lon = app['map']['bbox']['min_lng'].to_f.floor
    max_lon = app['map']['bbox']['max_lng'].to_f.ceil

    puts "Downloading height data for [#{min_lat}..#{max_lat}]x[#{min_lon}..#{max_lon}]..."

    names = (min_lat..max_lat).map{|lat| (min_lon..max_lon).map{|lon| "N#{lat}E0#{lon}" } }.flatten
    names.each do |name|
      `cd '#{heightdir}' && wget http://dds.cr.usgs.gov/srtm/version2_1/SRTM3/Eurasia/#{name}.hgt.zip` unless File.exists? heightdir.join("#{name}.hgt.zip")
      `cd '#{heightdir}' && yes | '#{Rails.root.join('vendor', 'bin', 'srtm_generate_hdr')}' #{name}.hgt.zip` unless File.exists? heightdir.join("#{name}.tif")
    end

    puts "Merging height data..."
    system "cd '#{heightdir}' && rm -rf all.tif && gdal_merge.py -v -o all.tif -ul_lr #{min_lon} #{max_lat+1} #{max_lon+1} #{min_lat} #{names.map{|n|"#{n}.tif"}.join(' ')}" or raise StandardError.new("Error merging data")

    puts "Reprojecting height data..."
    system "cd '#{heightdir}' && rm -rf warped.tif && gdalwarp -of GTiff -co 'TILED=YES' -srcnodata 32767 -t_srs '+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m' -rcs -order 3 -tr 30 30 -multi all.tif warped.tif" or raise StandardError.new("Error reprojecting data")

    puts "Generating hillshades..."
    system "cd '#{heightdir}' && rm -rf hillshade.tif && '#{Rails.root.join('vendor', 'bin', 'hillshade')}' warped.tif hillshade.tif -z 16 -wd 3" or raise StandardError.new("Error generating hillshade")

    puts "Success!"
  end

  desc "Import latest osm map"
  task :import do
    geography = true

    ENV['DB_CONFIG'] ||= Rails.root.join('config', 'database.yml')

    db = YAML.load(File.open ENV['DB_CONFIG'])[Rails.env]

    importdir = Rails.root.join('tmp', 'import')
    FileUtils.rm_rf importdir
    FileUtils.mkdir importdir

    unless ENV['UPDATE']
      if ENV['FILE'] # Dump is present, just import it
        dump_file = File.expand_path(ENV['FILE'])
      else # Dump should be downloaded
        dump_url = "http://data.gis-lab.info/osm_dump/dump/latest/RU-KLU.osm.pbf"
        dump_file = importdir.join(dump_url.split('/').last)

        puts "Downloading OSM dump..."
        system "cd '#{importdir}' && wget '#{dump_url}'" or raise StandardError.new("Error downloading dump from '#{dump_url}'")
      end

      puts "Importing osm data..."
      ENV['PGPASS'] = db['password']
      system "cd '#{importdir}' && '#{Rails.root.join('vendor', 'bin', 'osm2pgsql')}' -e 1-18 -o expire.list -j #{geography ? "-l" : "-m"} -G -S #{Rails.root.join('config', 'osm2pgsql.style')} -U #{db['username']} -d #{db['database']} -H #{db['host']} -p raw_osm '#{dump_file}'" or raise StandardError.new("Error importing data")
    end

    puts "Converting osm data"

    OsmImport.import 'config/mapping.rb', :pg => { :dbname => db['database'], :user => db['username'], :password => db['password'], :host => db['host'] }, :projection => (geography ? nil : 900913)

    puts "Success!"
  end

  desc "Render map"
  task :render do
    require 'ruby_mapnik'
    require 'map_utils'

    db_conf_file = ENV['DB_CONFIG'] || Rails.root.join('config', 'database.yml')
    db = YAML.load(File.open db_conf_file)[Rails.env]

    app_conf_file = ENV['APP_CONFIG'] || Rails.root.join('config', 'mapapp.yml')
    app = YAML.load(File.open app_conf_file)[Rails.env]

    minzoom = (ENV['MINZOOM'] || app['map']['min_zoom']).to_i
    maxzoom = (ENV['MAXZOOM'] || app['map']['max_zoom']).to_i
    styles = (ENV['STYLES'].try(:split, ',') || app['map']['styles'])

    styles.each do |style|

      if File.exists? Rails.root.join('..', '..', 'shared')
        heightdir = Rails.root.join('..', '..', 'shared', 'heights')
        tiledir = Rails.root.join('..', '..', 'shared', 'tiles', style)
      else
        heightdir = Rails.root.join('tmp', 'heights')
        tiledir = Rails.root.join('public', 'tiles', style)
      end

      tmpdir = Rails.root.join('tmp', 'render')
      FileUtils.rm_rf tmpdir
      FileUtils.mkdir tmpdir

      puts "Preparing '#{style}' mapnik style..."

      xml = File.read(Rails.root.join('config', 'mapnik', "#{style}.xml"))
      xml.gsub! "<Parameter name=\"dbname\"><![CDATA[gis]]></Parameter>","<Parameter name=\"dbname\"><![CDATA[#{db['database']}]]></Parameter>"
      xml.gsub! "<Parameter name=\"user\"><![CDATA[gis]]></Parameter>","<Parameter name=\"user\"><![CDATA[#{db['username']}]]></Parameter>"
      xml.gsub! "<Parameter name=\"password\"><![CDATA[zsedcft]]></Parameter>","<Parameter name=\"password\"><![CDATA[#{db['password']}]]></Parameter>"
      xml.gsub! /CDATA\[[^\]]+hillshade.tif\]/, "CDATA[hillshade.tif]"

      File.open "#{tmpdir}/mapnik.xml", "w" do |f|
        f.write xml
      end

      FileUtils.ln_s heightdir.join('hillshade.tif'), tmpdir.join('hillshade.tif')
      FileUtils.ln_s Rails.root.join('public', 'images'), tmpdir.join('images')
      FileUtils.mkdir_p tiledir

      puts "Loading mapnik config..."

      map = Mapnik::Map.from_file "#{tmpdir}/mapnik.xml"

      puts "Rendering..."

      min_lat = app['map']['bbox']['min_lat'].to_f
      max_lat = app['map']['bbox']['max_lat'].to_f
      min_lng = app['map']['bbox']['min_lng'].to_f
      max_lng = app['map']['bbox']['max_lng'].to_f

      (minzoom..maxzoom).each do |z|
        minx, maxy = MapUtils.zoom_lat_lng_to_x_y(z, min_lat, min_lng).map(&:floor)
        maxx, miny = MapUtils.zoom_lat_lng_to_x_y(z, max_lat, max_lng).map(&:floor)

        puts "Startinx zoom: #{[z, minx, miny, maxx, maxy].inspect}"

        (minx..maxx).each do |x|
          FileUtils.mkdir_p "#{tmpdir}/tiles/#{z}/#{x}"
          (miny..maxy).each do |y|
            tile = "#{tmpdir}/tiles/#{z}/#{x}/#{y}"

            Mapnik::Tile.new(z,x,y).render(map, "#{tile}.png", "png256")

            system "pngnq -f -n 50 '#{tile}.png' && mv '#{tile}-nq8.png' '#{tile}.png'" if style == 'light'
          end
        end

        puts "Moving zoom..."

        FileUtils.rm_rf "#{tiledir}/#{z}"
        FileUtils.move "#{tmpdir}/tiles/#{z}", "#{tiledir}/#{z}"
      end

      puts "Rendering style '#{style}' completed!"
    end
  end

  desc "Import new version of map and rerender it"
  task :update => [:import, :render] do
    puts "Ok, map updated!"
  end

end
