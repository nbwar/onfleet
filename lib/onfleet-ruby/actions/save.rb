module Onfleet
  module Actions
    module Save
      def save
        if respond_to?('id') && self.id
          request_type = :put
          api_url = "#{self.api_url}/#{self.id}"
        else
          request_type = :post
          api_url = self.api_url
        end
        response = Onfleet.request(api_url, request_type, self.attributes)
        self.parse_response(response)
      end
    end
  end
end
