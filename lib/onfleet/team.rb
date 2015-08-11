module Onfleet
  class Team < OnfleetObject
    include Onfleet::Actions::List
    include Onfleet::Actions::Get

    def self.url
      '/teams'
    end
  end
end
