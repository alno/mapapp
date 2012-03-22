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

    set_rgeo_factory_for_column(:geometry, render_proj)
  end

  module ClassMethods

    def render_proj
      @render_proj ||= RGeo::Geos.factory(:srid => 900913, :proj4 => " +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +units=m +k=1.0 +nadgrids=@null +no_defs", :coord_sys => 'PROJCS["Popular Visualisation CRS / Mercator (deprecated)",GEOGCS["Popular Visualisation CRS",DATUM["Popular_Visualisation_Datum",SPHEROID["Popular Visualisation Sphere",6378137.0,0.0,AUTHORITY["EPSG","7059"]],TOWGS84[0.0,0.0,0.0,0.0,0.0,0.0,0.0],AUTHORITY["EPSG","6055"]],PRIMEM["Greenwich",0.0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4055"]],PROJECTION["Mercator_1SP"],PARAMETER["central_meridian",0.0],PARAMETER["scale_factor",1.0],PARAMETER["false_easting",0.0],PARAMETER["false_northing",0.0],UNIT["metre",1.0,AUTHORITY["EPSG","9001"]],AXIS["X",EAST],AXIS["Y",NORTH],AUTHORITY["EPSG","3785"]]') or raise StandardError.new("Couldn't initialize geos factory!")
    end

    def latlng_proj
      @latlng_proj ||= RGeo::Geos.factory(:srid => 4326, :proj4 => " +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0", :coord_sys => 'GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137.0,298.257223563,AUTHORITY["EPSG","7030"]],AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0.0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4326"]]') or raise StandardError.new("Couldn't initialize geos factory!")
    end

  end

end
