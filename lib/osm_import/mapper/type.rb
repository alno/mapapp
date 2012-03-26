require 'osm_import/mapper'

class OsmImport::Mapper::Type < OsmImport::Mapper::Base

  def initialize(*args)
    super

    @mappings = []
    @multi = false
  end

  def assigns
    { "#{name}_street" => "src.tags->'addr:street'", "#{name}_housenumber" => "src.tags->'addr:housenumber'", "#{name}_city" => "src.tags->'addr:city'" , "#{name}_postcode" => "src.tags->'addr:postcode'" }
  end

  def fields
    { "#{name}_street" => "VARCHAR(255)", "#{name}_housenumber" => 'VARCHAR(255)', "#{name}_city" => "VARCHAR(255)", "#{name}_postcode" => "VARCHAR(100)" }
  end

  def conditions
    [ @mappings.map{|m| m[1] ? "(src.tags->'#{m[0]}') IN ('#{m[1].join("','")}')" : "(src.tags->'#{m[0]}') IS NOT NULL" }.join(' OR ') ]
  end

  def expression
    "CASE #{@mappings.map{|m| m[1] ? "WHEN (src.tags->'#{m[0]}') IN ('#{m[1].join("','")}') THEN src.tags->'#{m[0]}'" : "WHEN (src.tags->'#{m[0]}') IS NOT NULL THEN src.tags->'#{m[0]}'"}.join(' ')} END"
  end

  def after_import(tt)
    tt.conn.exec "UPDATE #{tt.name} SET #{name}_city = NULL WHERE #{name}_city = 'undefined'"
    tt.conn.exec "UPDATE #{tt.name} SET #{name}_city = c.name FROM raw_osm_polygon c WHERE geometry && way AND ST_Contains(Geometry(way), Geometry(geometry)) AND c.place IN ('city','town','village') AND c.name IS NOT NULL AND c.name <> '' AND #{name}_city IS NULL"
  end

  def add_args(*args)
    args.each do |arg|
      if arg.is_a? Hash
        arg.each(&method(:add_arg))
      else
        add_arg arg, nil
      end
    end
  end

  def add_arg(key, value)
    key = to_key(key)

    if key == 'multi'
      @multi = value
    else
      @mappings << [key, to_keylist(value)]
    end
  end

  private

  def to_key(key)
    raise StandardError.new("Invalid key #{key.inspect}") unless key.is_a? String or key.is_a? Symbol
    key.to_s
  end

  def to_keylist(list)
    if list.nil?
      list
    elsif list.is_a? Array
      list.map(&method(:to_key))
    else
      [to_key(list)]
    end
  end

end
