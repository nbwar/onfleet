module Onfleet
  class Destination < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Save
    include Onfleet::Actions::Get
    include Onfleet::Actions::QueryMetadata

    def self.api_url
      'destinations'
    end
  end
end

