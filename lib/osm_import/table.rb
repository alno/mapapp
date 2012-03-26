require 'osm_import'

class OsmImport::Table

  attr_reader :type, :name, :type_mapper, :mappers, :after_create_callbacks, :after_import_callbacks

  def initialize(type, name, &block)
    require 'osm_import/mapper'

    @type = type.to_s.gsub(/s$/,'')
    @name = name
    @type_mapper = OsmImport::Mapper.new(:type, :type)
    @mappers = {}
    @after_create_callbacks = []
    @after_import_callbacks = []

    dsl.instance_eval(&block) if block
  end

  def dsl
    @dsl ||= Dsl.new self
  end

  class Dsl < Struct.new(:table)

    def with(*args)
      args.each do |arg|
        if arg.is_a? Hash
          arg.each(&method(:add_mapper))
        else
          add_mapper arg, nil
        end
      end
    end

    def map(*args)
      table.type_mapper.add_args(*args)
    end

    def after_create(&block)
      table.after_create_callbacks << block
    end

    def after_import(&block)
      table.after_import_callbacks << block
    end

    private

    def add_mapper(key, type)
      table.mappers[key.to_s] = OsmImport::Mapper.new key, type
    end

  end

end
