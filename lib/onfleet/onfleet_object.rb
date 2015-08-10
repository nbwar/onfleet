module Onfleet
  class OnfleetObject
    def initialize

    end

    def parse_response response
      raise NotImplementedError.new("Subclass has not implemented parse_response")
    end
  end
end
