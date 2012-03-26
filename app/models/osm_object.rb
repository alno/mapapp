class OsmObject < ActiveRecord::Base

  self.inheritance_column = "ar_type"

  define_index do
    indexes :name

    indexes "(SELECT string_agg(keywords, ' ') FROM categories JOIN unnest(type_array) ON type = unnest WHERE \"table\" = 'objects')", :as => :keywords

    has "RADIANS(ST_Y(GEOMETRY(center)))",  :as => :latitude,  :type => :float
    has "RADIANS(ST_X(GEOMETRY(center)))", :as => :longitude, :type => :float

    has "(SELECT string_agg(replace(ancestry, '/', ',') || ',' || categories.id, ',') FROM categories JOIN unnest(type_array) ON type = unnest WHERE \"table\" = 'objects')", :as => :category_ids, :type => :multi, :facet => true

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
