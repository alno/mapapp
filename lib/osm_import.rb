module OsmImport

  module Autoloading

    def const_missing(c)
      require "#{underscore name}/#{underscore c}"
      const_get c
    end

    def [](c)
      const_get(camelize c)
    end

    private

    # Based on https://github.com/intridea/omniauth/blob/v1.0.2/lib/omniauth.rb#L129-139
    def camelize(str)
      str.to_s.gsub(/\/(.?)/){ "::" + $1.upcase }.gsub(/(^|_)(.)/){ $2.upcase }
    end

    def underscore(str)
      str.to_s.gsub(/::(.?)/){ "/" + $1.downcase }.gsub(/(.)([A-Z])/){ "#{$1}_#{$2.downcase}" }.downcase
    end

  end

  def self.import(mapping_file, options = {})
    require 'osm_import/schema'
    require 'osm_import/target'

    schema = Schema.load mapping_file
    target = Target.new :pg, options

    target.import(schema)
  end

end
