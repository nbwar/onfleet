module Onfleet
  class Admin < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Save
    include Onfleet::Actions::Update
    include Onfleet::Actions::List
    include Onfleet::Actions::Delete
    include Onfleet::Actions::QueryMetadata

    def self.api_url
      'admins'
    end
  end
end

