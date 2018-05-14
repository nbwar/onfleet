module Onfleet
  class Organization < OnfleetObject
    class << self
      def get
        new(Onfleet.request('organization', :get))
      end

      def get_delegatee_details(id)
        new(Onfleet.request("organizations/#{id}", :get))
      end
    end
  end
end

