module Onfleet
  class Recipient < Base
    onfleet_api at: 'recipients', actions: %i[find get create update save query_metadata]
  end
end

