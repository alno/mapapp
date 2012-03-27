require 'osm_models'

class OsmObject < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  include OsmModels::Address
  include OsmModels::Name

  define_index do
    indexes :name
    indexes OsmObject.address_sql, :as => :address
    indexes "(SELECT string_agg(keywords, ' ') FROM categories JOIN unnest(type_array) ON type = unnest WHERE \"table\" = 'objects')", :as => :keywords

    has "RADIANS(ST_Y(GEOMETRY(center)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(GEOMETRY(center)))", :as => :longitude, :type => :float

    has "(SELECT string_agg(replace(ancestry, '/', ',') || ',' || categories.id, ',') FROM categories JOIN unnest(type_array) ON type = unnest WHERE \"table\" = 'objects')", :as => :category_ids, :type => :multi, :facet => true
  end

  def category
    Category.where(:table => 'objects', :type => type).first
  end

  def categories
    Category.where(:table => 'objects').where('type IN (?)', type_array)
  end

  def types
    type_array or []
  end

  def table
    'objects'
  end

end
