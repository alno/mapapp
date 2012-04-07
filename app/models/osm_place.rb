require 'osm_models'

class OsmPlace < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  include OsmModels::Name

  define_index do
    indexes :name
    indexes "(SELECT keywords FROM categories WHERE \"table\" = 'places' AND types @> ARRAY[osm_places.type])", :as => :keywords

    has "RADIANS(ST_Y(GEOMETRY(center)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(GEOMETRY(center)))", :as => :longitude, :type => :float

    has "(SELECT replace(ancestry, '/', ',') || ',' || categories.id FROM categories WHERE \"table\" = 'places' AND types @> ARRAY[osm_places.type])", :as => :category_ids, :type => :multi, :facet => true

    where "name IS NOT NULL"
  end

  def category
    categories.first
  end

  def categories
    Category.where(:table => 'places').where('types @> ARRAY[?]', type)
  end

  def types
    [type]
  end

  def table
    'places'
  end

end
