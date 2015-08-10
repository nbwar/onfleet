module Onfleet
  class Recipient < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Update

    attr_accessor :id, :name, :phone, :notes, :skip_sms_notification, :skip_phone_nuber_validation

    class << Self
      def create params={}

      end
    end

    def url
      "/recipients"
    end

  end
end
