module Onfleet
  module Actions
    module Find
      module ClassMethods
        def find(field, search_term)
          encoded_term = URI.encode_www_form_component(search_term)
          url = "#{api_url}/#{field}/#{encoded_term}"

          response = Onfleet.request(url, :get)
          new(response)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

