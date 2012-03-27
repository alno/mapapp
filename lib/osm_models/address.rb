module OsmModels::Address

  extend ActiveSupport::Concern

  ADDRESS_FIELDS = [:address_city, :address_street, :address_housenumber]

  def address
    addr = ADDRESS_FIELDS.map{|f| self[f] }.compact

    if addr.empty?
      nil
    else
      addr.join(', ')
    end
  end

  module ClassMethods

    def address_fields
      ADDRESS_FIELDS
    end

    def address_sql
      ADDRESS_FIELDS.map{|f| "COALESCE(#{f},'')" }.join(" || ' ' || ")
    end

  end

end
