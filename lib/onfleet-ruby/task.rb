module Onfleet
  class Task < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Save
    include Onfleet::Actions::Update
    include Onfleet::Actions::Get
    include Onfleet::Actions::ShortGet
    include Onfleet::Actions::List
    include Onfleet::Actions::Delete
    include Onfleet::Actions::QueryMetadata

    def self.api_url
      'tasks'
    end

    def complete
      # CURRENTLY DOESN'T WORK
      url = "#{self.url}/#{id}/complete"
      params = { 'completionDetails' => { 'success' => true } }
      Onfleet.request(url, :post, params)
      true
    end
  end
end
