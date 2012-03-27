require 'osm_import/mapper'

class OsmImport::Mapper::Center < OsmImport::Mapper::Base

  def assigns
    {}
  end

  def fields
    {}
  end

  def indexes
    { name => "GIST(#{name})" }
  end

  def after_create(tt)
    tt.add_geometry_column name, :point
  end

  def after_import(tt)
    tt.conn.exec "UPDATE #{tt.name} SET #{name} = ST_PointOnSurface(Geometry(geometry)) WHERE #{name} IS NULL"
  end

end
