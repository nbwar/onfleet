module Onfleet
  class Task < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Save
    include Onfleet::Actions::Update
    include Onfleet::Actions::Get
    include Onfleet::Actions::List
    include Onfleet::Actions::Delete


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
