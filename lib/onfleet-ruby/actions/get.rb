module Onfleet
  module Actions
    module Get
      module ClassMethods
        def get(id)
          api_url = "#{self.api_url}/#{id}"
          response = Onfleet.request(api_url, :get)
          Util.constantize("#{self}").new(response)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

