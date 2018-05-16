require 'active_support/core_ext/string/inflections'
require 'onfleet-ruby/dsl'

module Onfleet
  class OnfleetObject
    extend Onfleet::Dsl

    attr_reader :params
    attr_accessor :id

    def initialize(params = {})
      if params.is_a?(Hash)
        parse_params(params)
      elsif params.is_a?(String)
        parse_params(id: params)
      end
    end

    def attributes
      attrs = {}
      instance_variables.reject { |var| var == '@params' }.each do |var|
        str = var.to_s.gsub(/^@/, '')
        next unless respond_to?("#{str}=")
        instance_var = instance_variable_get(var)
        if object_classes[str]
          if instance_var.is_a?(OnfleetObject)
            attrs[camelize(str).to_sym] = parse_onfleet_obj(instance_var)
          elsif instance_var.is_a?(Array)
            objs = []
            instance_var.each do |object|
              objs << parse_onfleet_obj(object)
            end
            attrs[camelize(str).to_sym] = objs
          else
            attrs[camelize(str).to_sym] = instance_var
          end
        else
          attrs[camelize(str).to_sym] = instance_var
        end
      end
      attrs
    end

    private

    def api_url
      self.class.api_url
    end

    def parse_params(params)
      @params = params

      params.each do |key, value|
        key_underscore = key.to_s.underscore

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

        if respond_to?("#{key_underscore}=")
          send(:"#{key_underscore}=", value)
        else
          add_attrs(key_underscore.to_s => value)
        end
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
        obj.attributes
      end
    end

    def add_attrs(attrs)
      attrs.each do |var, value|
        self.class.class_eval { attr_accessor var }
        instance_variable_set "@#{var}", value
      end
    end
  end
end

