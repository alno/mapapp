require 'rgeo'
require 'rgeo/active_record'

RGeo::ActiveRecord::DEFAULT_FACTORY_GENERATOR = Proc.new do |cfg|
  RGeo::Geos.factory(cfg.merge(:srs_database => RGeo::CoordSys::SRSDatabase::ActiveRecordTable.new))
end
