require 'osm_models'

class OsmBuilding < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  include OsmModels::Address
  include OsmModels::Name

  define_index do
    indexes :name
    indexes OsmBuilding.address_sql, :as => :address
    indexes "(SELECT keywords FROM categories WHERE \"table\" = 'buildings' AND type = osm_buildings.type)", :as => :keywords

    has "RADIANS(ST_Y(ST_CENTROID(GEOMETRY(geometry))))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(ST_CENTROID(GEOMETRY(geometry))))", :as => :longitude, :type => :float

    has "(SELECT replace(ancestry, '/', ',') || ',' || categories.id FROM categories WHERE \"table\" = 'buildings' AND type = osm_buildings.type)", :as => :category_ids, :type => :multi, :facet => true
  end

  def center
    if RGeo::Feature::Point === geometry
      geometry
    else
      geometry.point_on_surface
    end
  end

  def category
    Category.where(:table => 'buildings', :type => type).first
  end

  def categories
    Category.where(:table => 'buildings', :type => type)
  end

  def types
    [type]
  end

  def table
    'buildings'
  end

end
