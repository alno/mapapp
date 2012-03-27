require 'osm_models'

class OsmRoad < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  include OsmModels::Name

  define_index do
    indexes :name
    indexes "(SELECT keywords FROM categories WHERE \"table\" = 'roads' AND type = osm_roads.type)", :as => :keywords

    has "RADIANS(ST_Y(ST_CENTROID(GEOMETRY(geometry))))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(ST_CENTROID(GEOMETRY(geometry))))", :as => :longitude, :type => :float

    has "(SELECT replace(ancestry, '/', ',') || ',' || categories.id FROM categories WHERE \"table\" = 'roads' AND type = osm_roads.type)", :as => :category_ids, :type => :multi, :facet => true

    where "name IS NOT NULL AND NOT (name ILIKE '%(%дубл_р%)%')"
  end

  def center
    geometry.points[geometry.points.size / 2] # Median
  end

  def category
    Category.where(:table => 'roads', :type => type).first
  end

  def categories
    Category.where(:table => 'roads', :type => type)
  end

  def types
    [type]
  end

  def table
    'roads'
  end

end
