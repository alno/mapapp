require 'osm_import'

class OsmImport::Schema

  attr_reader :tables

  def self.load(file)
    new { eval File.read(file) }
  end

  def initialize(&block)
    @tables = []

    dsl.instance_eval(&block) if block
  end

  def dsl
    @dsl ||= Dsl.new self
  end

  class Dsl < Struct.new(:schema)

    def multipolygons(name, &block)
      table :multipolygons, name, &block
    end

    def multilines(name, &block)
      table :multilines, name, &block
    end

    def polygons(name, &block)
      table :polygons, name, &block
    end

    def lines(name, &block)
      table :lines, name, &block
    end

    def points(name, &block)
      table :points, name, &block
    end

    def table(type, name, &block)
      require 'osm_import/table'

      schema.tables << OsmImport::Table.new(type, name, &block)
    end

  end

end
