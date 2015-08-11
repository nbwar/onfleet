module Onfleet
  class Organization < OnfleetObject
    attr_accessor :id, :time_created, :time_last_modified, :name, :email, :timezone, :country, :delegatees

    class << self
      def get
        url = "/organization"
        response  = Onfleet.request(url, :get)
        Util.constantize("#{self}").new(response)
      end

      def get_delegatee_details id
        url = "/organizations/#{id}"
        response  = Onfleet.request(url, :get)
        Util.constantize("#{self}").new(response)
      end
    end

  end
end
