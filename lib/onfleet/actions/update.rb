module Onfleet
  module Actions
    module Update
      module ClassMethods
        def update(id, params)
          new(params.merge(id: id)).save
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

