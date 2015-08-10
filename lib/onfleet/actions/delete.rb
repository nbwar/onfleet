module Onfleet
  module Actions
    module Delete
      module ClassMethods
        def delete id
          url = "#{self.url}/#{id}"
          response = Onfleet.request(url, :delete)
          true
        end
      end

      def self.included base
        base.extend(ClassMethods)
      end
    end
  end
end
