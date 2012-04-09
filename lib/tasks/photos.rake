namespace :photos do

  namespace :import do

    task :panoramio => :environment do
      require 'open-uri'

      params = {}
      params[:set] = 'public'
      params[:size] = 'medium'
      params[:minx] = Mapapp.config['map']['bbox']['min_lng']
      params[:maxx] = Mapapp.config['map']['bbox']['max_lng']
      params[:miny] = Mapapp.config['map']['bbox']['min_lat']
      params[:maxy] = Mapapp.config['map']['bbox']['max_lat']

      from = 0
      count = 100

      while from < count
        json = JSON.parse(open("http://www.panoramio.com/map/get_panoramas.php?from=#{from}&to=#{from+100}&#{params.map{|k,v| "#{k}=#{v}"}.join('&')}").read)

        json['photos'].each do |photo_json|
          photo = Photo.find_by_url(photo_json['photo_url']) || Photo.new
          photo.service = 'panoramio'
          photo.url = photo_json['photo_url']
          photo.title = photo_json['photo_title']
          photo.image_url = photo_json['photo_file_url']
          photo.thumb_url = photo_json['photo_file_url'].gsub('/medium/','/thumb/')
          photo.author_name = photo_json['owner_name']
          photo.author_url = photo_json['owner_url']
          photo.width = photo_json['width']
          photo.height = photo_json['height']
          photo.location = RGeo::Geos.factory(:srid => 4326, :srs_database => RGeo::CoordSys::SRSDatabase::ActiveRecordTable.new)
          photo.save!
        end

        count = json['count'].to_i
        from = from + 100
      end
    end

  end

end
