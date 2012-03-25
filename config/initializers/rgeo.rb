require 'rgeo'
require 'rgeo/active_record'

class SrcCache

  def initialize
    @cache = {}
  end

  def call(cfg)
    @cache[cfg] ||= RGeo::Geos.factory(cfg.merge(:srs_database => RGeo::CoordSys::SRSDatabase::ActiveRecordTable.new))
  end

end

RGeo::ActiveRecord::DEFAULT_FACTORY_GENERATOR = SrcCache.new
