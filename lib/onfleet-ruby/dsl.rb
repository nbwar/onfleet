module Onfleet
  module Dsl
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def onfleet_api(at:, actions:)
        actions.each { |action| include Onfleet::Actions.const_get(action.to_s.camelize) }
        singleton_class.define_method(:api_url) { at }
      end

      def associated_with(associated)
        associated = associated.to_s

        define_single_association_getter(associated)
        define_single_association_setter(associated)
      end

      def associated_with_many(associated)
        associated = associated.to_s

        define_many_association_getter(associated)
        define_many_association_setter(associated)
      end

      private

      def define_single_association_getter(associated)
        define_method(associated) { attributes[associated] }
      end

      def define_single_association_setter(associated)
        require "onfleet-ruby/#{associated}"
        associated_class = Onfleet.const_get(associated.to_s.camelize)

        define_method(:"#{associated}=") do |value|
          attributes[associated] = build_from_attributes(associated_class, value)
        end
      end

      def define_many_association_getter(associated)
        define_method(associated) { attributes[associated] || [] }
      end

      def define_many_association_setter(associated)
        singular = associated.to_s.singularize
        require "onfleet-ruby/#{singular}"
        associated_class = Onfleet.const_get(singular.camelize)

        define_method(:"#{associated}=") do |values|
          values &&= values.collect { |value| build_from_attributes(associated_class, value) }
          attributes[associated] = values
        end
      end
    end

    def build_from_attributes(klass, value)
      value && (value.respond_to?(:id) ? value : klass.new(value))
    end
  end
end

