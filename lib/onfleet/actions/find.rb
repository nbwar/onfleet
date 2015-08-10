module Onfleet
  module Actions
    module Find
      class << Self
        def find field, search_term
          url = "#{self.url}/#{field}/#{search_term}"
          response  = Onfleet.request(url, :get, search_term)
          # Need to create a new object here first then parse the response
          parse_response(response)
        end
      end
    end
  end
end
