module Onfleet
  class Destination < OnfleetObject
    onfleet_api at: 'destinations', actions: %i[create save get query_metadata]
    associated_with :address
  end
end

