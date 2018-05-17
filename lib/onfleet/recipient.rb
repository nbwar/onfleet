module Onfleet
  class Recipient < OnfleetObject
    onfleet_api at: 'recipients', actions: %i[find get create update save query_metadata]
  end
end

