require 'active_support/core_ext/string/inflections'

module Onfleet
  class Util
    def self.object_classes
      @object_classes ||= {
        'address'     => Address,
        'recipients'  => Recipient,
        'recipient'   => Recipient,
        'tasks'       => Task,
        'destination' => Destination,
        'vehicle'     => Vehicle
      }
    end
  end
end

