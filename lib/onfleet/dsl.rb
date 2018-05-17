module Onfleet
  module Dsl
    def self.included(klass)
      klass.prepend(Decorations)
      klass.extend(ClassMethods)
    end

    module Decorations
      def as_json(*)
        id_only = self.class.id_only_attributes + self.class.id_only_collections
        json = super(except: id_only)
        json = serialize_id_only_attributes(json)
        serialize_id_only_collections(json)
      end

      private

      def serialize_id_only_attributes(json)
        self.class.id_only_attributes.inject(json) do |result, attribute|
          value = public_send(attribute)
          result.merge(attribute => value && value.id)
        end
      end

      def serialize_id_only_collections(json)
        self.class.id_only_collections.inject(json) do |result, attribute|
          collection = public_send(attribute)
          result.merge(attribute => collection.collect(&:id))
        end
      end
    end

    module ClassMethods
      def onfleet_api(at:, actions:)
        actions.each { |action| include Onfleet::Actions.const_get(action.to_s.camelize) }
        singleton_class.define_method(:api_url) { at }
      end

      def associated_with(associated, serialize_as: :object)
        associated = associated.to_s

        define_single_association_getter(associated)
        define_single_association_setter(associated)

        id_only_attributes << associated if serialize_as.to_sym == :id
      end

      def associated_with_many(associated, serialize_as: :object)
        associated = associated.to_s

        define_many_association_getter(associated)
        define_many_association_setter(associated)

        id_only_collections << associated if serialize_as.to_sym == :id
      end

      def id_only_attributes
        @id_only_attributes ||= []
      end

      def id_only_collections
        @id_only_collections ||= []
      end

      private

      def define_single_association_getter(associated)
        define_method(associated) { attributes[associated] }
      end

      def define_single_association_setter(associated)
        require "onfleet/#{associated}"
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
        require "onfleet/#{singular}"
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

