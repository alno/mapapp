polygons :places do
  with :center

  map :place => [:city, :town, :village]

  after_import do
    # TODO
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
    # TODO
  end
end

polygons :territories do
  map :landuse
end

polygons :buildings do
  map :building

  with :address
end

polygons :objects do
  with :address, :center
  map :leisure, :amenity

  after_import do |tt|
    tt.conn.exec "UPDATE new_osm_objects SET address_city = COALESCE(new_osm_objects.address_city,b.address_city), address_street = COALESCE(new_osm_objects.address_street, b.address_street), address_housenumber = COALESCE(new_osm_objects.address_housenumber, b.address_housenumber), address_postcode = b.address_postcode FROM new_osm_buildings b WHERE b.geometry && new_osm_objects.geometry AND ST_Intersects(b.geometry,new_osm_objects.geometry)"
  end
end
