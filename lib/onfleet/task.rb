module Onfleet
  class Task < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Save
    include Onfleet::Actions::Update
    include Onfleet::Actions::Get
    include Onfleet::Actions::List
    include Onfleet::Actions::Delete

    attr_accessor :id, :time_created, :time_last_modified, :organization, :short_id, :worker, :merchant, :executor,
                  :creator, :destination, :recipients, :state, :complete_after, :complete_before, :pickup_task, :notes,
                  :dependencies, :auto_assign, :tracking_url, :completion_details, :feedback, :metadata

    def self.url
      '/tasks'
    end

    def complete
      # CURRENTLY DOESN'T WORK WITH API
      # url = "#{self.url}/#{self.id}/complete"
      # params = {"completionDetails" => {"success" => "true" }}
      # response = Onfleet.request(url, :post, params)
    end

  end
end
