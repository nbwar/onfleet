module Onfleet
  module Actions
    module List
      module ClassMethods
        def list query_params={}
          url = "#{self.url}"

          if !query_params.empty?
            url += "?"
            query_params.each do |key, value|
              url += "#{key}=#{value}&"
            end
          end

          response = Onfleet.request(url, :get)
          response.compact.map do |listObj|
            Util.constantize("#{self}").new(listObj)
          end
        end
      end

      def self.included base
        base.extend(ClassMethods)
      end
    end
  end
end
