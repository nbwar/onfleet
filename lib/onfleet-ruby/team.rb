module Onfleet
  class Team < OnfleetObject
    include Onfleet::Actions::List
    include Onfleet::Actions::Get

    def self.api_url
      'teams'
    end
  end
end

