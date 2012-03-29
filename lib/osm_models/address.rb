module OsmModels::Address

  extend ActiveSupport::Concern

  DISPLAY_ADDRESS_FIELDS = [:city, :street, :housenumber]
  ALL_ADDRESS_FIELDS = [:postcode, :city, :street, :housenumber]

  def address
    addr = DISPLAY_ADDRESS_FIELDS.map{|f| self[f] }.compact

    if addr.empty?
      nil
    else
      addr.join(', ')
    end
  end

  module ClassMethods

    def display_address_fields
      DISPLAY_ADDRESS_FIELDS
    end

    def address_sql
      ALL_ADDRESS_FIELDS.map{|f| "COALESCE(#{f},'')" }.join(" || ' ' || ")
    end

  end

end
