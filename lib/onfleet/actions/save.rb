module Onfleet
  module Actions
    module Save
      def save
        if self.id
          request_type = :put
          url = "#{self.url}/#{self.id}"
        else
          request_type  = :post
          url = self.url
        end
        response = Onfleet.request(url, request_type, self.attributes)
        self.parse_response(response)
      end
    end
  end
end
