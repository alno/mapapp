require 'osm_import'

class OsmImport::Table

  attr_reader :type, :name, :mapping, :mappers

  def initialize(type, name, &block)
    @type = type.to_s.gsub(/s$/,'')
    @name = name
    @mapping = {}
    @mappers = {}

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
      args.each do |arg|
        if arg.is_a? Hash
          arg.each(&method(:add_mapping))
        else
          add_mapping arg, nil
        end
      end
    end

    def after_create
    end

    def after_import
    end

    private

    def add_mapper(key, type)
      require 'osm_import/mapper'

      table.mappers[to_key(key)] = OsmImport::Mapper.new key, type
    end

    def add_mapping(key, values)
      table.mapping[to_key(key)] = to_keylist(values)
    end

    def to_key(key)
      raise StandardError.new("Invalid key #{key.inspect}") unless key.is_a? String or key.is_a? Symbol
      key.to_s
    end

    def to_keylist(list)
      if list.nil?
        list
      elsif list.is_a? Array
        list.map(&method(:to_key))
      else
        [to_key(list)]
      end
    end

  end

end
