require 'osm_import'
require 'pg'

class OsmImport::Target::Pg < Struct.new(:options)

  def srid
    @srid ||= options[:srid] or options['srid'] or 4326
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

    puts "Creating tables and importing data:"

    schema.tables.each do |table|

      mapping_cond = table.mapping.map{|k,v| v ? "(src.tags->'#{k}') IN ('#{v.join("','")}')" : "(src.tags->'#{k}') IS NOT NULL" }.join(' OR ')
      mapping_type = "CASE #{table.mapping.map{|k,v| v ? "WHEN (src.tags->'#{k}') IN ('#{v.join("','")}') THEN src.tags->'#{k}'" : "WHEN (src.tags->'#{k}') IS NOT NULL THEN src.tags->'#{k}'"}.join(' ')} END"

      fields = { :id => 'INT8 PRIMARY KEY', :type => 'VARCHAR(100) NOT NULL', :name => 'VARCHAR(255)', :tags => 'HSTORE' }
      assigns = { :id => 'src.osm_id', :type => mapping_type, :name => "COALESCE(src.tags->'name:ru', src.tags->'name', src.tags->'int_name')", :tags => 'src.tags' }
      conds = [ mapping_cond ]

      table.mappers.each do |key, mapper|
        fields.merge! mapper.fields
        assigns.merge! mapper.assigns
      end

      # Creating table
      conn.exec "CREATE TABLE #{new_prefix}#{table.name}(#{fields.map{|k,v| "#{k} #{v}"}.join(', ')})"

      tt = Table.new self, conn, "#{new_prefix}#{table.name}"
      tt.add_geometry_column :geometry, table.type

      table.mappers.each do |key, mapper|
        mapper.after_create(tt)
      end

      # Importing data to table

      if table.type == 'polygon'
        geometry_assign = 'ST_Multi(way)'
      else
        geometry_assign = 'way'
      end

      field_keys = fields.keys.to_a
      conn.exec "INSERT INTO #{new_prefix}#{table.name}(geometry, #{field_keys.join(', ')}) SELECT #{geometry_assign} AS geometry, #{field_keys.map{|k| "#{assigns[k]} AS #{k}"}.join(',')} FROM raw_osm_#{table.type} src WHERE #{conds.join(' AND ')}"

      # Creating indexes

      conn.exec "CREATE INDEX #{new_prefix}#{table.name}_geometry_index ON #{new_prefix}#{table.name} USING GIST(geometry)"

      table.mappers.each do |key, mapper|
        mapper.after_import(tt)
      end
    end

    puts "Moving tables"

    schema.tables.each do |table|
      conn.exec "DROP TABLE IF EXISTS #{prefix}#{table.name}"
      conn.exec "ALTER TABLE #{new_prefix}#{table.name} RENAME TO #{prefix}#{table.name}"
      conn.exec "ALTER INDEX #{new_prefix}#{table.name}_geometry_index RENAME TO #{prefix}#{table.name}_geometry_index"
    end

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
      @conn = PG.connect options
    end

    def exec(q)
      puts "  #{q}"
      @conn.exec q
    end

    def close
      @conn.close
    end

  end

  class Table < Struct.new(:target, :conn, :name)

    def add_geometry_column(column, type)
      conn.exec "SELECT AddGeometryColumn('#{name}', '#{column}', #{target.srid}, '#{target.geometry_type type}', 2)"
    end

  end

end
