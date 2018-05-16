module Onfleet
  class Team < OnfleetObject
    onfleet_api at: 'teams', actions: %i[list get]
  end
end

