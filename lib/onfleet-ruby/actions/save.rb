module Onfleet
  module Actions
    module Save
      def save
        if respond_to?('id') && id
          request_type = :put
          api_url = "#{self.api_url}/#{id}"
        else
          request_type = :post
          api_url = self.api_url
        end
        response = Onfleet.request(api_url, request_type, attributes)
        parse_response(response)
      end
    end
  end
end

