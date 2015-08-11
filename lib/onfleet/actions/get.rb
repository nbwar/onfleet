module Onfleet
  module Actions
    module Get
      module ClassMethods
        def get id
          url = "#{self.url}/#{id}"
          response  = Onfleet.request(url, :get)
          Util.constantize("#{self}").new(response)
        end
      end

      def self.included base
        base.extend(ClassMethods)
      end
    end
  end
end
