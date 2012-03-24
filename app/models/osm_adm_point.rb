require 'active_record/geo_model'

class OsmAdmPoint < ActiveRecord::Base
  include ActiveRecord::GeoModel

  self.inheritance_column = "ar_type"

  define_index do
    indexes :name

    has "RADIANS(ST_Y(ST_TRANSFORM(ST_CENTROID(geometry), 4326)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(ST_TRANSFORM(ST_CENTROID(geometry), 4326)))", :as => :longitude, :type => :float

    where "name IS NOT NULL"
  end

end
