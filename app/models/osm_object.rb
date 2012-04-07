require 'osm_models'

class OsmObject < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  include OsmModels::Address
  include OsmModels::Name

  define_index do
    indexes :name
    indexes :city
    indexes OsmObject.address_sql, :as => :address
    indexes "(SELECT string_agg(keywords, ' ') FROM categories WHERE \"table\" = 'objects' AND (categories.types && osm_objects.types))", :as => :keywords

    has "RADIANS(ST_Y(GEOMETRY(center)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(GEOMETRY(center)))", :as => :longitude, :type => :float

    has "(SELECT string_agg(replace(ancestry, '/', ',') || ',' || categories.id, ',') FROM categories WHERE \"table\" = 'objects' AND (categories.types && osm_objects.types))", :as => :category_ids, :type => :multi, :facet => true
  end

  def category
    categories.first
  end

  def categories
    Category.where(:table => 'objects').where('types && ARRAY[?]::varchar(255)[]', types)
  end

  def types
    self[:types] or []
  end

  def table
    'objects'
  end

end
