module Onfleet
  class Team < OnfleetObject
    include Onfleet::Actions::List
    include Onfleet::Actions::Get

    attr_accessor :id, :time_created, :time_last_modified, :name, :workers, :managers

    def self.url
      '/teams'
    end
  end
end
