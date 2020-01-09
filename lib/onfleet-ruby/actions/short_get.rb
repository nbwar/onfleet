module Onfleet
  module Actions
    module ShortGet
      module ClassMethods
        def short_get(id)
          api_url = "#{self.api_url}/short/#{id}"
          response = Onfleet.request(api_url, :get)
          Util.constantize(name).new(response)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
