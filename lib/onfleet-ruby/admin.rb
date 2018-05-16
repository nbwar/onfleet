module Onfleet
  class Admin < OnfleetObject
    onfleet_api at: 'admins', actions: %i[list create update save delete query_metadata]
  end
end

