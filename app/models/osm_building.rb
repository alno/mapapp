class OsmBuilding < ActiveRecord::Base
  include OsmModel

  def housenumber
    self['addr:housenumber']
  end

end
