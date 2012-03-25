require 'osm_import/mapper'

class OsmImport::Mapper::Address < OsmImport::Mapper::Base

  def assigns
    { "#{name}_street" => "src.tags->'addr:street'", "#{name}_housenumber" => "src.tags->'addr:housenumber'", "#{name}_city" => "src.tags->'addr:city'" , "#{name}_postcode" => "src.tags->'addr:postcode'" }
  end

  def fields
    { "#{name}_street" => "VARCHAR(255)", "#{name}_housenumber" => 'VARCHAR(255)', "#{name}_city" => "VARCHAR(255)", "#{name}_postcode" => "VARCHAR(100)" }
  end

  def after_import(tt)
    tt.conn.exec "UPDATE #{tt.name} SET #{name}_city = NULL WHERE #{name}_city = 'undefined'"
    tt.conn.exec "UPDATE #{tt.name} SET #{name}_city = c.name FROM raw_osm_polygon c WHERE geometry && way AND ST_Contains(Geometry(way), Geometry(geometry)) AND c.place IN ('city','town','village') AND c.name IS NOT NULL AND c.name <> '' AND #{name}_city IS NULL"
  end

end
