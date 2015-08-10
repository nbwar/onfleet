module Onfleet
  class OnfleetObject
    attr_reader :params
    def initialize params
      if params.kind_of?(Hash)
        @params = params
        set_attributes(@params)
      elsif params.kind_of?(String)
        @params = {id: params}
        set_attributes(@params)
      else
        @params = {}
      end
    end

    def parse_response response
      @params = response
      set_attributes(response)
      self
    end

    def attributes
      attrs = Hash.new
      instance_variables.each do |var|
        str = var.to_s.gsub /^@/, ''
        if respond_to? "#{str}="
          instance_var = instance_variable_get(var)
          if klass = Util.object_classes[str]
            if instance_var.is_a?(OnfleetObject)
              attrs[Util.to_camel_case_lower(str).to_sym] = parse_onfleet_obj(instance_var)
            elsif instance_var.is_a?(Array)
              objs = []
              instance_var.each do |object|
                objs << parse_onfleet_obj(object)
              end
              attrs[Util.to_camel_case_lower(str).to_sym] = objs
            end
          else
            attrs[Util.to_camel_case_lower(str).to_sym] = instance_var
          end
        end
      end
      attrs
    end

    def class_name
      self.class.name.split("::").last
    end

    def url
      "/#{CGI.escape(class_name.downcase)}s"
    end

    private

      def parse_onfleet_obj obj
        if obj.is_a?(OnfleetObject)
          if obj.is_a?(Destination) || obj.is_a?(Recipient)
             obj.id
          else
            obj.attributes
          end
        end
      end

      def set_attributes params
        params.each do |key, value|
          key_underscore = Util.to_underscore(key)

          klass = Util.object_classes[key.to_s]
          if klass
            case value
            when Array
              objs = []
              value.each do |v|
                objs << klass.new(v)
              end
              value = objs
            when Hash
              value = klass.new(value)
            else
              raise ArgumentError.new("shit is fucked")
            end
          end

          if respond_to?("#{key_underscore}=")
            send(:"#{key_underscore}=", value)
          else
            raise ArgumentError.new("Cannot set '#{key_underscore}' for class '#{class_name}'.")
          end

        end
      end

  end
end
