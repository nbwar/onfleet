module Onfleet
  class Destination < Base
    onfleet_api at: 'destinations', actions: %i[create save get query_metadata]
    associated_with :address
  end
end

