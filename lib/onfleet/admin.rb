module Onfleet
  class Admin < Base
    onfleet_api at: 'admins', actions: %i[list create update save delete query_metadata]
  end
end

