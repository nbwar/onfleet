RSpec.describe Onfleet::Worker do
  let(:worker) { described_class.new(params) }
  let(:params) { { id: 'a-worker', name: 'F. Prefect', phone: '5551212' } }

  describe ".list" do
    subject { -> { described_class.list(query_params) } }

    context "with no filter" do
      let(:query_params) { nil }
      it_should_behave_like Onfleet::Actions::List, path: 'workers'
    end

    context "with query params" do
      let(:query_params) { { food: 'pizza', topping: 'mushroom' } }
      it_should_behave_like Onfleet::Actions::List, path: 'workers?food=pizza&topping=mushroom'
    end

    context "with a URL-unsafe query param" do
      let(:query_params) { { food: 'green eggs & ham' } }
      it_should_behave_like Onfleet::Actions::List, path: 'workers?food=green+eggs+%26+ham'
    end
  end

  describe ".create" do
    subject { -> { described_class.create(params) } }
    it_should_behave_like Onfleet::Actions::Create, path: 'workers'
  end

  describe ".get" do
    subject { -> { described_class.get(id) } }
    let(:id) { 'a-worker' }
    it_should_behave_like Onfleet::Actions::Get, path: 'workers/a-worker'
  end

  describe ".update" do
    subject { -> { described_class.update(id, params) } }
    let(:id) { 'a-worker' }
    it_should_behave_like Onfleet::Actions::Update, path: 'workers/a-worker'
  end

  describe ".delete" do
    subject { -> { described_class.delete(id) } }
    let(:id) { 'a-worker' }
    it_should_behave_like Onfleet::Actions::Delete, path: 'workers/a-worker'
  end

  describe ".query_by_metadata" do
    subject { -> { described_class.query_by_metadata(metadata) } }
    let(:metadata) { [{ name: 'color', type: 'string', value: 'ochre' }] }
    it_should_behave_like Onfleet::Actions::QueryMetadata, path: 'workers'
  end

  describe "#save" do
    subject { -> { worker.save } }

    context "with an ID attribute" do
      before { expect(params[:id]).to be }
      it_should_behave_like Onfleet::Actions::Update, path: 'workers/a-worker'
    end

    context "without an ID attribute" do
      let(:params) { { name: 'An Worker' } }
      it_should_behave_like Onfleet::Actions::Create, path: 'workers'
    end
  end
end

