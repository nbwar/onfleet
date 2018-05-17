module Onfleet
  module Actions
    module Save
      def save
        response = Onfleet.request(save_url, request_type, as_json)
        parse_params(response)
        self
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

