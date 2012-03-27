module OsmModels

  class << self

    def const_missing(c)
      require "osm_models/#{underscore c}"
      const_get c
    end

    def underscore(str)
      str.to_s.gsub(/::(.?)/){ "/" + $1.downcase }.gsub(/(.)([A-Z])/){ "#{$1}_#{$2.downcase}" }.downcase
    end

  end

end
