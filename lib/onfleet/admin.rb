module Onfleet
  class Admin < OnfleetObject
    include Onfleet::Actions::Create
    include Onfleet::Actions::Save
    include Onfleet::Actions::Update
    include Onfleet::Actions::List
    include Onfleet::Actions::Delete

    attr_accessor :id, :time_created, :time_last_modified, :organization, :email, :type, :name, :is_active, :phone, :list, :metadata

    def self.url
      '/admins'
    end
  end
end
