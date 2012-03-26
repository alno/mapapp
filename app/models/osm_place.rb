class OsmPlace < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  define_index do
    indexes :name

    has "RADIANS(ST_Y(GEOMETRY(center)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(GEOMETRY(center)))", :as => :longitude, :type => :float

    where "name IS NOT NULL"
  end

  def categories
    Category.where("table = 'places' AND type = ?", type)
  end

  def types
    [type]
  end

  def table
    'places'
  end

end
