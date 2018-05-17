require 'active_support/core_ext/hash'

module Onfleet
  module Actions
    module Create
      module ClassMethods
        def create(params = {})
          new(params.symbolize_keys.except(:id)).save
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

