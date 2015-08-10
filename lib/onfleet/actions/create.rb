module Onfleet
  module Actions
    module Create
      class << Self
        def create params={}
          self.new(params).save
        end
      end
    end
  end
end
