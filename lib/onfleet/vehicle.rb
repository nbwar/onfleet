module Onfleet
  class Vehicle < OnfleetObject
    attr_accessor :id, :type, :description, :license_plate, :color
  end
end
