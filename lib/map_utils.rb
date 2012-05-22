module MapUtils
  include Math
  extend self

  def zoom_x_y_to_lat_lng(zoom, x, y)
    n = 2.0 ** zoom
    lon_deg = x / n * 360.0 - 180.0
    lat_rad = atan(sinh(Math::PI * (1 - 2 * y / n)))
    lat_deg = lat_rad * 180.0 / Math::PI
    [lon_deg, lat_deg]
  end

  def zoom_lat_lng_to_x_y(zoom, lat, lng)
    n = 2.0 ** zoom

    x = (lng + 180.0) * n / 360.0

    lat_rad = lat / 180.0 * Math::PI
    t = log((1 + sin(lat_rad)) / cos(lat_rad))
    y = n * (1 - t / Math::PI) / 2.0

    [x, y]
  end

end
