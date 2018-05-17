module Onfleet
  class Team < Base
    onfleet_api at: 'teams', actions: %i[list get]
    associated_with_many :tasks, serialize_as: :id
  end
end

