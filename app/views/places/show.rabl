object @place

attributes :id, :name, :table, :types, :tags

glue :center do
  attributes :x => :lng, :y => :lat
end

node :info do
  controller.render_to_string 'info'
end

node :geojson do
  RGeo::GeoJSON.encode(@place.geometry)
end
