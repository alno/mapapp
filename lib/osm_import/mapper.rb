require 'osm_import'

module OsmImport::Mapper

  extend OsmImport::Autoloading

  def self.new(name, type)
    self[(type || name).to_s].new(name)
  end

  class Base < Struct.new(:name)

    def fields
      { name => "VARCHAR(255)" }
    end

    def assigns
      { name => "src.tags->'#{name}'" }
    end

    def indexes
      {}
    end

    def after_create(*args)
    end

    def after_import(*args)
    end

  end

  class String < Base; end

end
