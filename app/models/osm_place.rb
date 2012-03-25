class OsmPlace < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  define_index do
    indexes :name

    has "RADIANS(ST_Y(GEOMETRY(center)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(GEOMETRY(center)))", :as => :longitude, :type => :float

    where "name IS NOT NULL"
  end

end
