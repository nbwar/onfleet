module Onfleet
  class Webhook < OnfleetObject
    onfleet_api at: 'webhooks', actions: %i[list create save delete]
  end
end

