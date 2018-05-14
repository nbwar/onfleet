module Onfleet
  module Actions
    module List
      module ClassMethods
        def list(query_params = {})
          api_url = self.api_url

          if query_params.any?
            api_url += '?'
            query_params.each do |key, value|
              api_url += "#{key}=#{value}&"
            end
          end

          response = Onfleet.request(api_url, :get)
          response.compact.map do |listObj|
            Util.constantize(name).new(listObj)
          end
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

