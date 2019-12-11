module Onfleet
  module Actions
    module Get
      module ClassMethods
        def get(id)
          url = "#{api_url}/#{id}"
          new(Onfleet.request(url, :get))
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

