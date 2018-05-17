module Onfleet
  class Worker < OnfleetObject
    onfleet_api at: 'workers', actions: %i[list get create update save delete query_metadata]
    associated_with :vehicle
    associated_with_many :tasks
  end
end

