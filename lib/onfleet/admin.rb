module Onfleet
  class Admin < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Save
    include Onfleet::Actions::Update
    include Onfleet::Actions::List
    include Onfleet::Actions::Delete


    def self.url
      '/admins'
    end
  end
end
