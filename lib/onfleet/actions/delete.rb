module Onfleet
  module Actions
    module Delete
      module ClassMethods
        def delete(id)
          Onfleet.request("#{api_url}/#{id}", :delete)
          true
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

