# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120326145203) do

  create_table "categories", :force => true do |t|
    t.string   "ancestry"
    t.string   "table"
    t.string   "type"
    t.string   "name",                :null => false
    t.text     "description"
    t.string   "icon"
    t.string   "keywords"
    t.string   "default_object_name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"
  add_index "categories", ["name"], :name => "index_categories_on_name", :unique => true
  add_index "categories", ["table", "type"], :name => "index_categories_on_table_and_type", :unique => true

  create_table "osm_barriers", :id => false, :force => true do |t|
    t.string  "type",     :limit => 100,                                                    :null => false
    t.hstore  "tags"
    t.string  "name"
    t.integer "id",       :limit => 8,                                                      :null => false
    t.spatial "geometry", :limit => {:type=>"line_string", :srid=>4326, :geographic=>true}
  end

  add_index "osm_barriers", ["geometry"], :name => "osm_barriers_geometry_index", :spatial => true
  add_index "osm_barriers", ["type"], :name => "osm_barriers_type_index"

  create_table "osm_buildings", :id => false, :force => true do |t|
    t.string  "address_housenumber"
    t.string  "address_postcode",    :limit => 100
    t.string  "type",                :limit => 100,                                                      :null => false
    t.string  "address_street"
    t.hstore  "tags"
    t.string  "address_city"
    t.string  "name"
    t.integer "id",                  :limit => 8,                                                        :null => false
    t.spatial "geometry",            :limit => {:type=>"multi_polygon", :srid=>4326, :geographic=>true}
  end

  add_index "osm_buildings", ["geometry"], :name => "osm_buildings_geometry_index", :spatial => true
  add_index "osm_buildings", ["type"], :name => "osm_buildings_type_index"

  create_table "osm_objects", :id => false, :force => true do |t|
    t.string       "address_housenumber"
    t.string       "address_postcode",    :limit => 100
    t.string       "type",                :limit => 100,                                                      :null => false
    t.string_array "type_array",          :limit => 100
    t.string       "address_street"
    t.hstore       "tags"
    t.string       "address_city"
    t.string       "name"
    t.integer      "id",                  :limit => 8,                                                        :null => false
    t.spatial      "geometry",            :limit => {:type=>"multi_polygon", :srid=>4326, :geographic=>true}
    t.spatial      "center",              :limit => {:type=>"point", :srid=>4326, :geographic=>true}
  end

  add_index "osm_objects", ["geometry"], :name => "osm_objects_geometry_index", :spatial => true
  add_index "osm_objects", ["type"], :name => "osm_objects_type_index"
  add_index "osm_objects", ["type_array"], :name => "osm_objects_type_array_index"

  create_table "osm_places", :id => false, :force => true do |t|
    t.string  "type",     :limit => 100,                                                      :null => false
    t.hstore  "tags"
    t.string  "name"
    t.integer "id",       :limit => 8,                                                        :null => false
    t.spatial "geometry", :limit => {:type=>"multi_polygon", :srid=>4326, :geographic=>true}
    t.spatial "center",   :limit => {:type=>"point", :srid=>4326, :geographic=>true}
  end

  add_index "osm_places", ["geometry"], :name => "osm_places_geometry_index", :spatial => true
  add_index "osm_places", ["type"], :name => "osm_places_type_index"

  create_table "osm_rails", :id => false, :force => true do |t|
    t.string  "type",     :limit => 100,                                                    :null => false
    t.hstore  "tags"
    t.string  "name"
    t.integer "id",       :limit => 8,                                                      :null => false
    t.spatial "geometry", :limit => {:type=>"line_string", :srid=>4326, :geographic=>true}
  end

  add_index "osm_rails", ["geometry"], :name => "osm_rails_geometry_index", :spatial => true
  add_index "osm_rails", ["type"], :name => "osm_rails_type_index"

  create_table "osm_roads", :id => false, :force => true do |t|
    t.string  "type",     :limit => 100,                                                    :null => false
    t.string  "ref"
    t.hstore  "tags"
    t.string  "name"
    t.integer "id",       :limit => 8,                                                      :null => false
    t.spatial "geometry", :limit => {:type=>"line_string", :srid=>4326, :geographic=>true}
  end

  add_index "osm_roads", ["geometry"], :name => "osm_roads_geometry_index", :spatial => true
  add_index "osm_roads", ["type"], :name => "osm_roads_type_index"

  create_table "osm_squares", :id => false, :force => true do |t|
    t.string  "type",     :limit => 100,                                                      :null => false
    t.hstore  "tags"
    t.string  "name"
    t.integer "id",       :limit => 8,                                                        :null => false
    t.spatial "geometry", :limit => {:type=>"multi_polygon", :srid=>4326, :geographic=>true}
  end

  add_index "osm_squares", ["geometry"], :name => "osm_squares_geometry_index", :spatial => true
  add_index "osm_squares", ["type"], :name => "osm_squares_type_index"

  create_table "osm_territories", :id => false, :force => true do |t|
    t.string  "type",     :limit => 100,                                                      :null => false
    t.hstore  "tags"
    t.string  "name"
    t.integer "id",       :limit => 8,                                                        :null => false
    t.spatial "geometry", :limit => {:type=>"multi_polygon", :srid=>4326, :geographic=>true}
  end

  add_index "osm_territories", ["geometry"], :name => "osm_territories_geometry_index", :spatial => true
  add_index "osm_territories", ["type"], :name => "osm_territories_type_index"

  create_table "osm_waterareas", :id => false, :force => true do |t|
    t.string  "type",     :limit => 100,                                                      :null => false
    t.hstore  "tags"
    t.string  "name"
    t.integer "id",       :limit => 8,                                                        :null => false
    t.spatial "geometry", :limit => {:type=>"multi_polygon", :srid=>4326, :geographic=>true}
  end

  add_index "osm_waterareas", ["geometry"], :name => "osm_waterareas_geometry_index", :spatial => true
  add_index "osm_waterareas", ["type"], :name => "osm_waterareas_type_index"

  create_table "osm_waterways", :id => false, :force => true do |t|
    t.string  "type",     :limit => 100,                                                    :null => false
    t.hstore  "tags"
    t.string  "name"
    t.integer "id",       :limit => 8,                                                      :null => false
    t.spatial "geometry", :limit => {:type=>"line_string", :srid=>4326, :geographic=>true}
  end

  add_index "osm_waterways", ["geometry"], :name => "osm_waterways_geometry_index", :spatial => true
  add_index "osm_waterways", ["type"], :name => "osm_waterways_type_index"

  create_table "pages", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug", :unique => true

  create_table "raw_osm_line", :id => false, :force => true do |t|
    t.integer "osm_id",             :limit => 8
    t.text    "access"
    t.text    "addr:housename"
    t.text    "addr:housenumber"
    t.text    "addr:interpolation"
    t.text    "admin_level"
    t.text    "aerialway"
    t.text    "aeroway"
    t.text    "amenity"
    t.text    "area"
    t.text    "barrier"
    t.text    "bicycle"
    t.text    "brand"
    t.text    "bridge"
    t.text    "boundary"
    t.text    "building"
    t.text    "construction"
    t.text    "covered"
    t.text    "culvert"
    t.text    "cutting"
    t.text    "denomination"
    t.text    "disused"
    t.text    "embankment"
    t.text    "foot"
    t.text    "generator:source"
    t.text    "harbour"
    t.text    "highway"
    t.text    "historic"
    t.text    "horse"
    t.text    "intermittent"
    t.text    "junction"
    t.text    "landuse"
    t.text    "layer"
    t.text    "leisure"
    t.text    "lock"
    t.text    "man_made"
    t.text    "military"
    t.text    "motorcar"
    t.text    "name"
    t.text    "natural"
    t.text    "oneway"
    t.text    "operator"
    t.text    "population"
    t.text    "power"
    t.text    "power_source"
    t.text    "place"
    t.text    "railway"
    t.text    "ref"
    t.text    "religion"
    t.text    "route"
    t.text    "service"
    t.text    "shop"
    t.text    "sport"
    t.text    "surface"
    t.text    "toll"
    t.text    "tourism"
    t.text    "tower:type"
    t.text    "tracktype"
    t.text    "tunnel"
    t.text    "water"
    t.text    "waterway"
    t.text    "wetland"
    t.text    "width"
    t.text    "wood"
    t.integer "z_order"
    t.float   "way_area"
    t.hstore  "tags"
    t.spatial "way",                :limit => {:no_constraints=>true}
  end

  add_index "raw_osm_line", ["way"], :name => "raw_osm_line_index", :spatial => true

  create_table "raw_osm_point", :id => false, :force => true do |t|
    t.integer "osm_id",             :limit => 8
    t.text    "access"
    t.text    "addr:housename"
    t.text    "addr:housenumber"
    t.text    "addr:interpolation"
    t.text    "admin_level"
    t.text    "aerialway"
    t.text    "aeroway"
    t.text    "amenity"
    t.text    "area"
    t.text    "barrier"
    t.text    "bicycle"
    t.text    "brand"
    t.text    "bridge"
    t.text    "boundary"
    t.text    "building"
    t.text    "capital"
    t.text    "construction"
    t.text    "covered"
    t.text    "culvert"
    t.text    "cutting"
    t.text    "denomination"
    t.text    "disused"
    t.text    "ele"
    t.text    "embankment"
    t.text    "foot"
    t.text    "generator:source"
    t.text    "harbour"
    t.text    "highway"
    t.text    "historic"
    t.text    "horse"
    t.text    "intermittent"
    t.text    "junction"
    t.text    "landuse"
    t.text    "layer"
    t.text    "leisure"
    t.text    "lock"
    t.text    "man_made"
    t.text    "military"
    t.text    "motorcar"
    t.text    "name"
    t.text    "natural"
    t.text    "oneway"
    t.text    "operator"
    t.text    "poi"
    t.text    "population"
    t.text    "power"
    t.text    "power_source"
    t.text    "place"
    t.text    "railway"
    t.text    "ref"
    t.text    "religion"
    t.text    "route"
    t.text    "service"
    t.text    "shop"
    t.text    "sport"
    t.text    "surface"
    t.text    "toll"
    t.text    "tourism"
    t.text    "tower:type"
    t.text    "tunnel"
    t.text    "water"
    t.text    "waterway"
    t.text    "wetland"
    t.text    "width"
    t.text    "wood"
    t.integer "z_order"
    t.hstore  "tags"
    t.spatial "way",                :limit => {:no_constraints=>true}
  end

  add_index "raw_osm_point", ["way"], :name => "raw_osm_point_index", :spatial => true

  create_table "raw_osm_polygon", :id => false, :force => true do |t|
    t.integer "osm_id",             :limit => 8
    t.text    "access"
    t.text    "addr:housename"
    t.text    "addr:housenumber"
    t.text    "addr:interpolation"
    t.text    "admin_level"
    t.text    "aerialway"
    t.text    "aeroway"
    t.text    "amenity"
    t.text    "area"
    t.text    "barrier"
    t.text    "bicycle"
    t.text    "brand"
    t.text    "bridge"
    t.text    "boundary"
    t.text    "building"
    t.text    "construction"
    t.text    "covered"
    t.text    "culvert"
    t.text    "cutting"
    t.text    "denomination"
    t.text    "disused"
    t.text    "embankment"
    t.text    "foot"
    t.text    "generator:source"
    t.text    "harbour"
    t.text    "highway"
    t.text    "historic"
    t.text    "horse"
    t.text    "intermittent"
    t.text    "junction"
    t.text    "landuse"
    t.text    "layer"
    t.text    "leisure"
    t.text    "lock"
    t.text    "man_made"
    t.text    "military"
    t.text    "motorcar"
    t.text    "name"
    t.text    "natural"
    t.text    "oneway"
    t.text    "operator"
    t.text    "population"
    t.text    "power"
    t.text    "power_source"
    t.text    "place"
    t.text    "railway"
    t.text    "ref"
    t.text    "religion"
    t.text    "route"
    t.text    "service"
    t.text    "shop"
    t.text    "sport"
    t.text    "surface"
    t.text    "toll"
    t.text    "tourism"
    t.text    "tower:type"
    t.text    "tracktype"
    t.text    "tunnel"
    t.text    "water"
    t.text    "waterway"
    t.text    "wetland"
    t.text    "width"
    t.text    "wood"
    t.integer "z_order"
    t.float   "way_area"
    t.hstore  "tags"
    t.spatial "way",                :limit => {:no_constraints=>true}
  end

  add_index "raw_osm_polygon", ["way"], :name => "raw_osm_polygon_index", :spatial => true

  create_table "raw_osm_roads", :id => false, :force => true do |t|
    t.integer "osm_id",             :limit => 8
    t.text    "access"
    t.text    "addr:housename"
    t.text    "addr:housenumber"
    t.text    "addr:interpolation"
    t.text    "admin_level"
    t.text    "aerialway"
    t.text    "aeroway"
    t.text    "amenity"
    t.text    "area"
    t.text    "barrier"
    t.text    "bicycle"
    t.text    "brand"
    t.text    "bridge"
    t.text    "boundary"
    t.text    "building"
    t.text    "construction"
    t.text    "covered"
    t.text    "culvert"
    t.text    "cutting"
    t.text    "denomination"
    t.text    "disused"
    t.text    "embankment"
    t.text    "foot"
    t.text    "generator:source"
    t.text    "harbour"
    t.text    "highway"
    t.text    "historic"
    t.text    "horse"
    t.text    "intermittent"
    t.text    "junction"
    t.text    "landuse"
    t.text    "layer"
    t.text    "leisure"
    t.text    "lock"
    t.text    "man_made"
    t.text    "military"
    t.text    "motorcar"
    t.text    "name"
    t.text    "natural"
    t.text    "oneway"
    t.text    "operator"
    t.text    "population"
    t.text    "power"
    t.text    "power_source"
    t.text    "place"
    t.text    "railway"
    t.text    "ref"
    t.text    "religion"
    t.text    "route"
    t.text    "service"
    t.text    "shop"
    t.text    "sport"
    t.text    "surface"
    t.text    "toll"
    t.text    "tourism"
    t.text    "tower:type"
    t.text    "tracktype"
    t.text    "tunnel"
    t.text    "water"
    t.text    "waterway"
    t.text    "wetland"
    t.text    "width"
    t.text    "wood"
    t.integer "z_order"
    t.float   "way_area"
    t.hstore  "tags"
    t.spatial "way",                :limit => {:no_constraints=>true}
  end

  add_index "raw_osm_roads", ["way"], :name => "raw_osm_roads_index", :spatial => true

  create_table "test", :id => false, :force => true do |t|
    t.integer      "id",    :limit => 8,   :null => false
    t.string_array "types", :limit => 255
    t.string       "name"
  end

  add_index "test", ["types"], :name => "test_types"

end
