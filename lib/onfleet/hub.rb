module Onfleet
  class Hub < Base
    onfleet_api at: 'hubs', actions: %i[list]
  end
end

