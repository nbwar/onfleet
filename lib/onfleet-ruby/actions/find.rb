module Onfleet
  module Actions
    module Find
      module ClassMethods
        def find field, search_term
          api_url = "#{self.api_url}/#{field}/#{search_term}"
          response = Onfleet.request(api_url, :get, search_term)
          Util.constantize("#{self}").new(response)
        end
      end

      def self.included base
        base.extend(ClassMethods)
      end
    end
  end
end
