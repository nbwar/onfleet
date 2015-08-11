module Onfleet
  class Worker < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::List
    include Onfleet::Actions::Get
    include Onfleet::Actions::Save
    include Onfleet::Actions::Update
    include Onfleet::Actions::Delete

    attr_accessor :id, :name, :phone, :teams, :vehicle, :organization, :time_created, :time_last_modified,
                  :active_task, :tasks, :on_duty, :location, :time_last_seen, :delay_time, :image, :metadata

    def self.url
      '/workers'
    end
  end
end
