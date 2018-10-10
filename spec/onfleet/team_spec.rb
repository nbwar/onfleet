RSpec.describe Onfleet::Team do
  let(:team) { described_class.new(params) }
  let(:params) { { id: 'a-team', name: 'Detroit Redwings' } }

  describe ".list" do
    subject { -> { described_class.list(query_params) } }

    context "with no filter" do
      let(:query_params) { nil }
      it_should_behave_like Onfleet::Actions::List, path: 'teams'
    end

    context "with query params" do
      let(:query_params) { { food: 'pizza', topping: 'mushroom' } }
      it_should_behave_like Onfleet::Actions::List, path: 'teams?food=pizza&topping=mushroom'
    end

    context "with a URL-unsafe query param" do
      let(:query_params) { { food: 'green eggs & ham' } }
      it_should_behave_like Onfleet::Actions::List, path: 'teams?food=green+eggs+%26+ham'
    end
  end

  describe ".get" do
    subject { -> { described_class.get(id) } }
    let(:id) { 'a-team' }
    it_should_behave_like Onfleet::Actions::Get, path: 'teams/a-team'
  end
end

