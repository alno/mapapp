require 'active_record/geo_model'

class OsmPlace < ActiveRecord::Base
  include ActiveRecord::GeoModel

  self.inheritance_column = "ar_type"

  define_index do
    indexes :name

    has "RADIANS(ST_Y(center))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(center))", :as => :longitude, :type => :float

    where "name IS NOT NULL"
  end

end
