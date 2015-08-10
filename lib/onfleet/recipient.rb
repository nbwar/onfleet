module Onfleet
  class Recipient < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Update
    include Onfleet::Actions::Save
    include Onfleet::Actions::Find
    include Onfleet::Actions::Get

    attr_accessor :id, :name, :phone, :notes, :skip_sms_notifications, :skip_phone_nuber_validation, :time_created, :time_last_modified, :metadata

    def self.url
      "/recipients"
    end
  end
end
