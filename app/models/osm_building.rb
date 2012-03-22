require 'active_record/geo_model'

class OsmBuilding < ActiveRecord::Base
  include ActiveRecord::GeoModel

  self.inheritance_column = "ar_type"

  define_index do
    indexes :name

    has "RADIANS(ST_Y(ST_TRANSFORM(ST_CENTROID(geometry), 4326)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(ST_TRANSFORM(ST_CENTROID(geometry), 4326)))", :as => :longitude, :type => :float

    where "name IS NOT NULL"
  end

  def address
    addr = [self['addr:postcode'], self['addr:city'], self['addr:street'], self['addr:housenumber']].compact

    if addr.empty?
      nil
    else
      addr.join(', ')
    end
  end

end
