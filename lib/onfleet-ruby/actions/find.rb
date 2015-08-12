module Onfleet
  module Actions
    module Find
      module ClassMethods
        def find field, search_term
          url = "#{self.url}/#{field}/#{search_term}"
          response = Onfleet.request(url, :get, search_term)
          Util.constantize("#{self}").new(response)
        end
      end

      def self.included base
        base.extend(ClassMethods)
      end
    end
  end
end
