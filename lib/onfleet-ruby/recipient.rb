module Onfleet
  class Recipient < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Update
    include Onfleet::Actions::Save
    include Onfleet::Actions::Find
    include Onfleet::Actions::Get

    def self.url
      "/recipients"
    end
  end
end
