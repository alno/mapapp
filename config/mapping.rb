polygons :places do
  with :center

  map :place => [:city, :town, :village]

  after_import do
    conn.exec "INSERT INTO #{name}(id,type,name,center,tags) SELECT osm_id, #{type_mapping} AS type, #{name_mapping} AS name, way, tags FROM raw_osm_point src WHERE #{conditions} AND (SELECT COUNT(1) FROM #{name} ep WHERE ep.geometry && src.way AND ST_Contains(Geometry(ep.geometry), src.way)) = 0"
    conn.exec "UPDATE #{name} SET tags = #{name}.tags || src.tags, center = src.way FROM raw_osm_point src WHERE #{conditions} AND #{name_mapping} = #{name}.name AND geometry && way AND ST_Contains(Geometry(geometry), way)"
  end
end

lines :roads do
  with :ref => :string

  map :highway
end

lines :rails do
  map :railway
end

polygons :squares do
  map :highway
end

lines :waterways do
  map :waterway => [:stream, :river, :canal, :drain, :ditch], :barrier => :ditch
end

polygons :waterareas do
  map :waterway => [:riverbank, :drain, :pond], :natural => [:water, :lake, :bay], :landuse => [:basin, :reservoir]
end

lines :barriers do
  map :barrier, :natural => :cliff, :man_made => :enbankment

  after_import do
    conn.exec "INSERT INTO #{name}(id,type,geometry) SELECT osm_id, #{type_mapping} AS type, ST_Boundary(way) FROM raw_osm_polygon src WHERE #{conditions}"
  end
end

polygons :territories do
  map :landuse, :natural => [:wood, :scrub, :wetland, :beach]
end

polygons :buildings do
  map :building, :power => :generator

  with :address
end

polygons :objects do
  with :address, :center
  map :leisure, :amenity, :tourism, :historic

  after_import do
    conn.exec "INSERT INTO #{name}(id,type,name,center,tags) SELECT osm_id, #{type_mapping} AS type, #{name_mapping} AS name, way, tags FROM raw_osm_point src WHERE #{conditions}"
    conn.exec "UPDATE #{name} SET address_city = COALESCE(#{name}.address_city,b.address_city), address_street = COALESCE(#{name}.address_street, b.address_street), address_housenumber = COALESCE(#{name}.address_housenumber, b.address_housenumber), address_postcode = COALESCE(#{name}.address_postcode, b.address_postcode) FROM new_osm_buildings b WHERE b.geometry && new_osm_objects.geometry AND ST_Intersects(b.geometry,new_osm_objects.geometry)"
  end
end
