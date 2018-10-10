module Onfleet
  module Actions
    module Update
      module ClassMethods
        def update(id, params)
          params[:id] = id
          new(params).save
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

