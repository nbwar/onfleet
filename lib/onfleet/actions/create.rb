module Onfleet
  module Actions
    module Create
      module ClassMethods
        def create params={}
          self.new(params).save
        end
      end

      def self.included base
        base.extend(ClassMethods)
      end
    end
  end
end
