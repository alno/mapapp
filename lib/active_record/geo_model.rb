module ActiveRecord::GeoModel

  extend ActiveSupport::Concern

  def centroid
    if RGeo::Feature::Point === geometry
      geometry
    else
      geometry.centroid
    end
  end

end
