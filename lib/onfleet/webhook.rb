module Onfleet
  class Webhook < Base
    onfleet_api at: 'webhooks', actions: %i[list create save delete]
  end
end

