module Onfleet
  class Destination < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Save
    include Onfleet::Actions::Get

    attr_accessor :id, :address, :location, :notes, :tasks, :time_created, :time_last_modified, :metadata

    def self.url
      '/destinations'
    end
  end
end
