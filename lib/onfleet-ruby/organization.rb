module Onfleet
  class Organization < OnfleetObject
    class << self
      def get
        url = "/organization"
        response = Onfleet.request(url, :get)
        Util.constantize("#{self}").new(response)
      end

      def get_delegatee_details id
        url = "/organizations/#{id}"
        response = Onfleet.request(url, :get)
        Util.constantize("#{self}").new(response)
      end
    end
  end
end
