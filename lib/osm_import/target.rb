require 'osm_import'

module OsmImport::Target

  extend OsmImport::Autoloading

  def self.new(name, options)
    self[name].new(options)
  end

end
