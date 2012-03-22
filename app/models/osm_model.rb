module OsmModel

  extend ActiveSupport::Concern

  def latlng_geometry
    @latlng_geometry ||= RGeo::Feature.cast(geometry, :factory => self.class.latlng_proj, :project => true)
  end

  def latlng_centroid
    @latlng_centroid ||= RGeo::Feature.cast(centroid, :factory => self.class.latlng_proj, :project => true)
  end

  def centroid
    if RGeo::Feature::Point === geometry
      geometry
    else
      geometry.centroid
    end
  end

  included do
    self.inheritance_column = "ar_type"
  end

  module ClassMethods

    def latlng_proj
      @latlng_proj ||= RGeo::Geos.factory(:srid => 4326, :proj4 => " +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0", :coord_sys => 'GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137.0,298.257223563,AUTHORITY["EPSG","7030"]],AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0.0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4326"]]') or raise StandardError.new("Couldn't initialize geos factory!")
    end

  end

end
