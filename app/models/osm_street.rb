require 'osm_models'

class OsmStreet < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  include OsmModels::Name

  define_index do
    indexes :name
    indexes :city
    indexes "(SELECT keywords FROM categories WHERE \"table\" = 'streets' AND type = osm_streets.type)", :as => :keywords

    has "RADIANS(ST_Y(GEOMETRY(center)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(GEOMETRY(center)))", :as => :longitude, :type => :float

    has "(SELECT replace(ancestry, '/', ',') || ',' || categories.id FROM categories WHERE \"table\" = 'streets' AND type = osm_streets.type)", :as => :category_ids, :type => :multi, :facet => true

    where "name IS NOT NULL AND NOT (name ILIKE '%(%дубл_р%)%')"
  end

  def address
    city
  end

  def category
    Category.where(:table => 'streets', :type => type).first
  end

  def categories
    Category.where(:table => 'streets', :type => type)
  end

  def types
    [type]
  end

  def table
    'streets'
  end

end
