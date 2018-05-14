module Onfleet
  module Actions
    module QueryMetadata
      module ClassMethods
        def query_by_metadata(metadata)
          response = Onfleet.request("#{api_url}/metadata", :post, metadata)
          [*response].compact.map { |item| new(item) }
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

