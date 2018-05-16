require 'active_support/core_ext/string/inflections'
require 'onfleet-ruby/dsl'

module Onfleet
  class OnfleetObject
    extend Onfleet::Dsl

    attr_reader :params

    def initialize(params = {})
      if params.is_a?(Hash)
        parse_params(params)
      elsif params.is_a?(String)
        parse_params(id: params)
      end
    end

    def id
      attributes['id']
    end

    def id=(value)
      attributes['id'] = value
    end

    def as_json
      attrs = {}
      attributes.each do |name, value|
        if object_classes[name]
          if value.is_a?(OnfleetObject)
            attrs[camelize(name).to_sym] = parse_onfleet_obj(value)
          elsif value.is_a?(Array)
            objs = []
            value.each do |object|
              objs << parse_onfleet_obj(object)
            end
            attrs[camelize(name).to_sym] = objs
          else
            attrs[camelize(name).to_sym] = value
          end
        else
          attrs[camelize(name).to_sym] = value
        end
      end
      attrs
    end

    private

    def attributes
      @attributes ||= {}
    end

    def api_url
      self.class.api_url
    end

    def parse_params(params)
      @params = params

      params.each do |key, value|
        key = key.to_s.underscore

        if (klass = object_classes[key.to_s])
          case value
          when Array
            objs = []
            value.each do |v|
              objs << klass.new(v)
            end
            value = objs
          when Hash
            value = klass.new(value)
          end
        end

        define_attribute_accessors(key) unless respond_to?(key)
        public_send(:"#{key}=", value)
      end
    end

    def camelize(string)
      camelized = string.camelize(:lower)
      camelized.gsub('Sms', 'SMS')
    end

    def object_classes
      @object_classes ||= {
        'address'     => Address,
        'recipients'  => Recipient,
        'recipient'   => Recipient,
        'tasks'       => Task,
        'destination' => Destination,
        'vehicle'     => Vehicle
      }
    end

    def parse_onfleet_obj(obj)
      return unless obj.is_a?(OnfleetObject)
      if obj.respond_to?('id') && obj.id && (obj.is_a?(Destination) || obj.is_a?(Recipient) || obj.is_a?(Task))
        obj.id
      else
        obj.as_json
      end
    end

    def define_attribute_accessors(attr)
      attr = attr.to_s

      singleton_class.define_method(:"#{attr}=") { |value| attributes[attr] = value }
      singleton_class.define_method(attr) { attributes[attr] }
    end
  end
end

