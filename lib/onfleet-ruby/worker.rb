module Onfleet
  class Worker < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::List
    include Onfleet::Actions::Get
    include Onfleet::Actions::Save
    include Onfleet::Actions::Update
    include Onfleet::Actions::Delete


    def self.api_url
      '/workers'
    end
  end
end
