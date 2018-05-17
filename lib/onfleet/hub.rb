module Onfleet
  class Hub < OnfleetObject
    onfleet_api at: 'hubs', actions: %i[list]
  end
end

