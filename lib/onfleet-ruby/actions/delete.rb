module Onfleet
  module Actions
    module Delete
      module ClassMethods
        def delete id
          api_url = "#{self.api_url}/#{id}"
          Onfleet.request(api_url, :delete)
          true
        end
      end

      def self.included base
        base.extend(ClassMethods)
      end
    end
  end
end

