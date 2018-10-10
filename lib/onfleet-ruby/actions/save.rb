module Onfleet
  module Actions
    module Save
      def save
        response = Onfleet.request(save_url, request_type, attributes)
        parse_response(response)
      end

      private

      def request_type
        id ? :put : :post
      end

      def save_url
        [api_url, id].compact.join('/')
      end
    end
  end
end

