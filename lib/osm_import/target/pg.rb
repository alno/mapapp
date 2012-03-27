require 'osm_import'
require 'pg'

class OsmImport::Target::Pg < Struct.new(:options)

  def projection
    options[:projection]
  end

  def prefix
    'osm_'
  end

  def new_prefix
    'new_osm_'
  end

  def import(schema)
    conn = Connection.new options

    conn.exec "BEGIN TRANSACTION"

    puts "Dropping old tables:"

    schema.tables.each do |table|
      conn.exec "DROP TABLE IF EXISTS #{new_prefix}#{table.name}"
    end

    puts "Preparing target tables"

    tts = schema.tables.map{|table| TargetTable.new self, conn, table }

    puts "Creating tables and importing data:"

    tts.each do |tt|
      tt.create! # Create table
      tt.import! # Import data to it
    end

    puts "Deploy tables"
    tts.each do |tt|
      tt.deploy!
    end

    puts "Restoring geometry columns"
    conn.exec "TRUNCATE geometry_columns"
    conn.exec "SELECT probe_geometry_columns()"

    puts "Commiting"
    conn.exec "COMMIT"
    conn.close
  end

  GEOTYPES = { 'point' => 'POINT', 'line' => 'LINESTRING', 'polygon' => 'MULTIPOLYGON' }

  def geometry_type(type)
    GEOTYPES[type.to_s] or raise StandardError.new("Unknown geometry type #{type.inspect}")
  end

  class Connection < Struct.new(:options)

    def initialize(*args)
      super
      @conn = PG.connect options[:pg]
    end

    def exec(q)
      puts "  #{q}"
      @conn.exec q
    end

    def close
      @conn.close
    end

  end

  class TargetTable

    attr_reader :target, :conn, :table, :type_mapping, :type_array_mapping, :name_mapping, :fields, :conditions, :assigns

    def initialize(target, conn, table)
      @target = target
      @conn = conn
      @table = table

      @type_mapping = table.type_mapper.expression
      @type_array_mapping = table.type_mapper.expression_multi
      @name_mapping = "NULLIF(COALESCE(src.tags->'name:ru', src.tags->'name', src.tags->'int_name'), '')"

      @fields = table.type_mapper.fields.merge :id => 'INT8 PRIMARY KEY',  :name => 'VARCHAR(255)', :tags => 'HSTORE', :osm_type => 'VARCHAR(10)'
      @assigns = table.type_mapper.assigns.merge :id => osm_id_expr, :name => name_mapping, :tags => 'src.tags', :osm_type => osm_type_expr
      @conditions = table.type_mapper.conditions

      table.mappers.each do |key, mapper|
        @fields.merge! mapper.fields
        @assigns.merge! mapper.assigns
      end
    end

    def osm_id_expr
      "ABS(src.osm_id)"
    end

    def osm_type_expr(t = table.type)
      "CASE WHEN src.osm_id < 0 THEN 'relation' ELSE '#{if t.to_s == 'point' then 'node' else 'way' end}' END"
    end

    def add_geometry_column(column, type)
      if target.projection
        conn.exec "SELECT AddGeometryColumn('#{name}', '#{column}', #{target.projection}, '#{target.geometry_type type}', 2)"
      else
        conn.exec "ALTER TABLE #{name} ADD COLUMN #{column} GEOGRAPHY(#{target.geometry_type type}, 4326)"
      end
    end

    def name
      "#{target.new_prefix}#{table.name}"
    end

    def create!
      conn.exec "CREATE TABLE #{name}(#{fields.map{|k,v| "#{k} #{v}"}.join(', ')})"
      add_geometry_column :geometry, table.type

      table.type_mapper.after_create self

      table.mappers.each do |key, mapper|
        mapper.after_create self
      end

      table.after_create_callbacks.each do |cb|
        instance_eval(&cb)
      end
    end

    def indexes
      @indexes ||= begin
        res = table.type_mapper.indexes
        res[:geometry] = "GIST(geometry)"

        table.mappers.each do |key,mapper|
          res.merge mapper.indexes
        end

        res
      end
    end

    def import!
      if table.type == 'polygon'
        geometry_assign = 'ST_Multi(way)'
      else
        geometry_assign = 'way'
      end

      field_keys = fields.keys.to_a
      conn.exec "INSERT INTO #{name}(geometry, #{field_keys.join(', ')}) SELECT #{geometry_assign} AS geometry, #{field_keys.map{|k| "#{assigns[k]} AS #{k}"}.join(',')} FROM raw_osm_#{table.type} src WHERE #{conditions.join(' AND ')}"

      # Creating indexes

      indexes.each do |key, desc|
        conn.exec "CREATE INDEX #{name}_#{key}_index ON #{name} USING #{desc}"
      end

      table.type_mapper.after_import self

      table.mappers.each do |key, mapper|
        mapper.after_import self
      end

      table.after_import_callbacks.each do |cb|
        instance_eval(&cb)
      end
    end

    def deploy!
      conn.exec "DROP TABLE IF EXISTS #{target.prefix}#{table.name}"
      conn.exec "ALTER TABLE #{name} RENAME TO #{target.prefix}#{table.name}"
      #conn.exec "ALTER INDEX #{name}_pkey RENAME TO #{target.prefix}#{table.name}_pkey"

      indexes.each do |key,_|
        conn.exec "ALTER INDEX #{name}_#{key}_index RENAME TO #{target.prefix}#{table.name}_#{key}_index"
      end

    end

  end

end
