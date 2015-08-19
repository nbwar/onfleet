module Onfleet
  class Webhook < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::List
    include Onfleet::Actions::Save
    include Onfleet::Actions::Delete


    def self.api_url
      '/webhooks'
    end
  end
end
