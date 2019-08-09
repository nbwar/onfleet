module Onfleet
  class Task < OnfleetObject
    onfleet_api at: 'tasks', actions: %i[list get create update save delete query_metadata]
    associated_with :destination, serialize_as: :id
    associated_with_many :recipients, serialize_as: :id
    associated_with_many :barcodes

    def complete
      # CURRENTLY DOESN'T WORK
      url = "#{self.url}/#{id}/complete"
      params = { 'completionDetails' => { 'success' => true } }
      Onfleet.request(url, :post, params)
      true
    end
  end
end

