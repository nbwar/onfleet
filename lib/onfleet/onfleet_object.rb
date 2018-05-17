require 'active_support/core_ext/string/inflections'
require 'active_support/json'
require 'active_support/core_ext/object/json'
require 'onfleet/dsl'

module Onfleet
  class OnfleetObject
    include Onfleet::Dsl

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

    def as_json(*options)
      attributes
        .as_json(*options)
        .transform_keys { |key| camelize_with_acronym(key) }
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
        define_attribute_accessors(key) unless respond_to?(key)
        public_send(:"#{key}=", value)
      end
    end

    def define_attribute_accessors(attr)
      attr = attr.to_s

      singleton_class.define_method(:"#{attr}=") { |value| attributes[attr] = value }
      singleton_class.define_method(attr) { attributes[attr] }
    end

    def camelize_with_acronym(string)
      camelized = string.camelize(:lower)
      camelized.gsub('Sms', 'SMS')
    end
  end
end

