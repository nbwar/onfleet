module Onfleet
  module Actions
    module List
      module ClassMethods
        def list(filters = {})
          response = Onfleet.request(list_url_for(filters), :get)
          response.compact.map { |item| new(item) }
        end

        def query_params(filters)
          filters && filters
            .collect { |key, value| "#{key}=#{URI.encode_www_form_component(value)}" }
            .join('&')
        end

        private

        def list_url_for(filters)
          [api_url, query_params(filters)].compact.join('?')
        end

      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

