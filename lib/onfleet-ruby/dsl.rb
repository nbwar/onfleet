module Onfleet
  module Dsl
    def onfleet_api(at:, actions:)
      actions.each { |action| include Onfleet::Actions.const_get(action.to_s.camelize) }
      singleton_class.define_method(:api_url) { at }
    end
  end
end

