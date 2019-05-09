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

  describe ".create" do
    subject { -> { described_class.create(params) } }
    it_should_behave_like Onfleet::Actions::Create, path: 'teams'
  end

  describe ".get" do
    subject { -> { described_class.get(id) } }
    let(:id) { 'a-team' }
    it_should_behave_like Onfleet::Actions::Get, path: 'teams/a-team'
  end

  describe ".update" do
    subject { -> { described_class.update(id, params) } }
    let(:id) { 'a-team' }
    it_should_behave_like Onfleet::Actions::Update, path: 'teams/a-team'
  end

  describe ".delete" do
    subject { -> { described_class.delete(id) } }
    let(:id) { 'a-team' }
    it_should_behave_like Onfleet::Actions::Delete, path: 'teams/a-team'
  end

  describe "#save" do
    subject { -> { team.save } }

    context "with an ID attribute" do
      before { expect(params[:id]).to be }
      it_should_behave_like Onfleet::Actions::Update, path: 'teams/a-team'
    end

    context "without an ID attribute" do
      let(:params) { { name: 'A Team' } }
      it_should_behave_like Onfleet::Actions::Create, path: 'teams'
    end
  end
end
