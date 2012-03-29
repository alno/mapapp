require 'osm_import/mapper'

class OsmImport::Mapper::Address < OsmImport::Mapper::Base

  def assigns
    { "street" => "src.tags->'addr:street'", "housenumber" => "src.tags->'addr:housenumber'", "city" => "src.tags->'addr:city'" , "postcode" => "src.tags->'addr:postcode'" }
  end

  def fields
    { "street" => "VARCHAR(255)", "housenumber" => 'VARCHAR(255)', "city" => "VARCHAR(255)", "postcode" => "VARCHAR(100)" }
  end

  def after_import(tt)
    tt.conn.exec "UPDATE #{tt.name} SET city = NULL WHERE city = 'undefined'"
    tt.conn.exec "UPDATE #{tt.name} SET city = c.name FROM raw_osm_polygon c WHERE geometry && way AND ST_Contains(way, Geometry(geometry)) AND c.place IN ('city','town','village') AND c.name IS NOT NULL AND c.name <> '' AND city IS NULL"
  end

end
