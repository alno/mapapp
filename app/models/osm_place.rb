class OsmPlace < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  define_index do
    indexes :name

    indexes "(SELECT keywords FROM categories WHERE \"table\" = 'places' AND type = osm_places.type)", :as => :keywords

    has "RADIANS(ST_Y(GEOMETRY(center)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(GEOMETRY(center)))", :as => :longitude, :type => :float

    has "(SELECT replace(ancestry, '/', ',') || ',' || categories.id FROM categories WHERE \"table\" = 'places' AND type = osm_places.type)", :as => :category_ids, :type => :multi, :facet => true

    where "name IS NOT NULL"
  end

  def name
    self['name'] || category.default_object_name
  end

  def category
    Category.where(:table => 'places', :type => type).first
  end

  def categories
    Category.where(:table => 'places', :type => type)
  end

  def types
    [type]
  end

  def table
    'places'
  end

end
