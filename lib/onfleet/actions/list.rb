module Onfleet
  module Actions
    module List
      module ClassMethods
        def list state=nil
          url = "#{self.url}?state=#{state}"
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
