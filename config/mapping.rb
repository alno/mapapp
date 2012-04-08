multipolygons :places do
  with :center

  map :place => [:city, :town, :village]

  after_import do
    conn.exec "INSERT INTO #{name}(id,osm_type,type,name,center,tags) SELECT #{osm_id_expr}, #{osm_type_expr :point}, #{type_mapping}, #{name_mapping}, way, tags FROM raw_osm_point src WHERE #{conditions} AND (SELECT COUNT(1) FROM #{name} ep WHERE ep.geometry && src.way AND ST_Contains(Geometry(ep.geometry), src.way)) = 0"
    conn.exec "UPDATE #{name} SET tags = #{name}.tags || src.tags, center = src.way FROM raw_osm_point src WHERE #{conditions} AND #{name_mapping} = #{name}.name AND geometry && way AND ST_Contains(Geometry(geometry), way)"
  end
end

lines :roads do
  with :ref => :string, :place_id => :id

  map :highway

  after_import do
    conn.exec "UPDATE #{name} SET place_id = new_osm_places.id from new_osm_places where st_intersects(new_osm_places.geometry,new_osm_roads.geometry) and new_osm_places.name is not null"
  end
end

multilines :streets do
  with :center, :city => :string, :place_id => :id

  after_create do # TODO More intellectual type selection
    conn.exec "INSERT INTO #{name}(id,osm_type,type,geometry,name,place_id) SELECT MIN(id), MIN(osm_type), 'street', ST_Multi(ST_Union(Geometry(geometry))), name, place_id FROM new_osm_roads WHERE name IS NOT NULL AND place_id IS NOT NULL GROUP BY name, place_id"
    conn.exec "UPDATE #{name} SET city = (SELECT name FROM new_osm_places WHERE id = place_id)"
  end
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

multipolygons :waterareas do
  map :waterway => [:riverbank, :drain, :pond], :natural => [:water, :lake, :bay], :landuse => [:basin, :reservoir]
end

multilines :barriers do
  map :barrier, :natural => :cliff, :man_made => :enbankment

  after_import do
    conn.exec "INSERT INTO #{name}(id,osm_type,type,geometry) SELECT #{osm_id_expr}, #{osm_type_expr :polygon}, #{type_mapping} AS type, ST_Multi(ST_Boundary(way)) FROM raw_osm_polygon src WHERE #{conditions}"
  end
end

multipolygons :territories do
  map :landuse, :natural => [:wood, :scrub, :wetland, :beach]
end

multipolygons :buildings do
  map :building, :power => :generator, :man_made => [:water_tower, :reservoir_covered, :tank, :water_tank, :water_works, :wastewater_plant, :tower, :communications_tower, :monitoring_station]

  with :address
end

multipolygons :objects do
  map :leisure, :amenity, :tourism, :shop, :office, :sport, :man_made => [:well, :water_well, :artesian_well], :historic => [:monument, :memorial, :ruins], :landuse => [:cemetery], :natural => [:spring], :multi => true

  with :address, :center

  after_import do
    conn.exec "INSERT INTO #{name}(id,osm_type,type,types,name,center,tags) SELECT #{osm_id_expr}, #{osm_type_expr :point}, #{type_mapping}, #{types_mapping}, #{name_mapping}, way, tags FROM raw_osm_point src WHERE #{conditions}"
    conn.exec "UPDATE #{name} SET city = COALESCE(#{name}.city,b.city), street = COALESCE(#{name}.street, b.street), housenumber = COALESCE(#{name}.housenumber, b.housenumber), postcode = COALESCE(#{name}.postcode, b.postcode) FROM new_osm_buildings b WHERE ST_Intersects(b.geometry,new_osm_objects.geometry) OR ST_Intersects(b.geometry,new_osm_objects.center)"
    conn.exec "UPDATE #{name} SET city = p.name FROM new_osm_places p WHERE #{name}.geometry && p.geometry AND ST_Contains(Geometry(p.geometry), Geometry(#{name}.geometry)) AND p.type IN ('city','town','village') AND p.name IS NOT NULL AND city IS NULL AND #{name}.geometry IS NOT NULL"
    conn.exec "UPDATE #{name} SET city = p.name FROM new_osm_places p WHERE #{name}.center && p.geometry AND ST_Contains(Geometry(p.geometry), Geometry(#{name}.center)) AND p.type IN ('city','town','village') AND p.name IS NOT NULL AND city IS NULL AND #{name}.geometry IS NULL"

    conn.exec "UPDATE new_osm_buildings SET name = NULL FROM #{name} WHERE #{name}.id = new_osm_buildings.id" # Remove names from buildings to exclude them from search
  end
end
