require 'active_record/geo_model'

class OsmObject < ActiveRecord::Base
  include ActiveRecord::GeoModel

  self.inheritance_column = "ar_type"

  define_index do
    indexes :name

    has "RADIANS(ST_Y(ST_CENTROID(geometry)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(ST_CENTROID(geometry)))", :as => :longitude, :type => :float

    where "name IS NOT NULL"
  end

  def address
    addr = [address_postcode, address_city, address_street, address_housenumber].compact

    if addr.empty?
      nil
    else
      addr.join(', ')
    end
  end

end
