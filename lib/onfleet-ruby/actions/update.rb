module Onfleet
  module Actions
    module Update
      module ClassMethods
        def update id, params
          params.merge!(id: id)
          self.new(params).save
        end
      end

      def self.included base
        base.extend(ClassMethods)
      end
    end
  end
end

