module Onfleet
  class Task < OnfleetObject
    onfleet_api at: 'tasks', actions: %i[list get create update save delete query_metadata]
    associated_with :destination
    associated_with_many :recipients

    def complete
      # CURRENTLY DOESN'T WORK
      url = "#{self.url}/#{id}/complete"
      params = { 'completionDetails' => { 'success' => true } }
      Onfleet.request(url, :post, params)
      true
    end
  end
end

