module Onfleet
  class Recipient < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Update
    include Onfleet::Actions::Save
    include Onfleet::Actions::Find
    include Onfleet::Actions::Get
    include Onfleet::Actions::QueryMetadata

    def self.api_url
      "/recipients"
    end
  end
end

