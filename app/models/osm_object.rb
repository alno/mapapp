class OsmObject < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  define_index do
    indexes :name

    has "RADIANS(ST_Y(GEOMETRY(center)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(GEOMETRY(center)))", :as => :longitude, :type => :float

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
