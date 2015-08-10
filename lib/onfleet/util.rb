module Onfleet
  class Util
    def self.contantize class_name
      Object.const_get(class_name)
    end
  end
end
