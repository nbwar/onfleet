RSpec.describe Onfleet::Hub do
  let(:hub) { described_class.new(params) }
  let(:params) { { id: 'a-hub', name: 'The Warehouse' } }

  it_should_behave_like Onfleet::Base

  describe ".list" do
    subject { -> { described_class.list(query_params) } }

    context "with no filter" do
      let(:query_params) { nil }
      it_should_behave_like Onfleet::Actions::List, path: 'hubs'
    end

    context "with query params" do
      let(:query_params) { { food: 'pizza', topping: 'mushroom' } }
      it_should_behave_like Onfleet::Actions::List, path: 'hubs?food=pizza&topping=mushroom'
    end

    context "with a URL-unsafe query param" do
      let(:query_params) { { food: 'green eggs & ham' } }
      it_should_behave_like Onfleet::Actions::List, path: 'hubs?food=green+eggs+%26+ham'
    end
  end
end

