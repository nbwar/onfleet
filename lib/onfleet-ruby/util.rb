module Onfleet
  class Util
    SPECIAL_PARSE = { "skip_sms_notifications" => "skipSMSNotifications" }

    def self.constantize class_name
      Object.const_get(class_name)
    end

    def self.to_underscore key
      if key.kind_of?(Symbol)
        key = key.to_s
      end
      key.gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        .gsub(/([a-z\d])([A-Z])/,'\1_\2')
        .tr("-", "_")
        .downcase
    end

    def self.to_camel_case_lower str
      SPECIAL_PARSE[str] || str.camelize(:lower)
    end

    def self.object_classes
      @object_classes ||= {
        "address"     => Address,
        "recipients"  => Recipient,
        "recipient"   => Recipient,
        "tasks"       => Task,
        "destination" => Destination,
        "vehicle"     => Vehicle
      }
    end
  end

end
