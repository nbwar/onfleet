module Onfleet
  module Actions
    module QueryMetadata
      module ClassMethods
        def query_by_metadata metadata
          api_url = "#{self.api_url}/metadata"
          response = Onfleet.request(api_url, :post, metadata)
          response.map { |item| Util.constantize("#{self}").new(item) } if response.is_a? Array
        end
      end

      def self.included base
        base.extend(ClassMethods)
      end
    end
  end
end

