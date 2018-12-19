module Onfleet
  class Task < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Save
    include Onfleet::Actions::Update
    include Onfleet::Actions::Get
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

    def self.list_all(filters)
      response = Onfleet.request(list_all_url_for(filters), :get)
      {
        lastId: response['lastId'],
        tasks: response['tasks'].compact.map { |item| new(item) }
      }
    end

    private

    def self.list_all_url_for(filters)
      [api_url + '/all', query_params(filters)].compact.join('?')
    end
  end
end

