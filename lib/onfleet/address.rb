module Onfleet
  class Address < OnfleetObject
    attr_accessor :name, :number, :street, :apartment, :city, :state, :postal_code, :country, :unparsed
  end
end
