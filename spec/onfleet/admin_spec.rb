RSpec.describe Onfleet::Admin do
  let(:admin) { described_class.new(params) }
  let(:params) { { id: 'an-admin', name: 'An Admin' } }

  describe ".list" do
    subject { -> { described_class.list(query_params) } }

    context "with no filter" do
      let(:query_params) { nil }
      it_should_behave_like Onfleet::Actions::List, path: 'admins'
    end

    context "with query params" do
      let(:query_params) { { food: 'pizza', topping: 'mushroom' } }
      it_should_behave_like Onfleet::Actions::List, path: 'admins?food=pizza&topping=mushroom'
    end

    context "with a URL-unsafe query param" do
      let(:query_params) { { food: 'green eggs & ham' } }
      it_should_behave_like Onfleet::Actions::List, path: 'admins?food=green+eggs+%26+ham'
    end
  end

  describe ".create" do
    subject { -> { described_class.create(params) } }
    it_should_behave_like Onfleet::Actions::Create, path: 'admins'
  end

  describe ".update" do
    subject { -> { described_class.update(id, params) } }
    let(:id) { 'an-admin' }
    it_should_behave_like Onfleet::Actions::Update, path: 'admins/an-admin'
  end

  describe ".delete" do
    subject { -> { described_class.delete(id) } }
    let(:id) { 'an-admin' }
    it_should_behave_like Onfleet::Actions::Delete, path: 'admins/an-admin'
  end

  describe ".query_by_metadata" do
    subject { -> { described_class.query_by_metadata(metadata) } }
    let(:metadata) { [{ name: 'color', type: 'string', value: 'ochre' }] }
    it_should_behave_like Onfleet::Actions::QueryMetadata, path: 'admins'
  end

  describe "#save" do
    subject { -> { admin.save } }

    context "with an ID attribute" do
      before { expect(params[:id]).to be }
      it_should_behave_like Onfleet::Actions::Update, path: 'admins/an-admin'
    end

    context "without an ID attribute" do
      let(:params) { { name: 'An Admin' } }
      it_should_behave_like Onfleet::Actions::Create, path: 'admins'
    end
  end

  %i[id name email type metadata].each do |attr|
    describe "##{attr}" do
      subject { admin.public_send(attr) }
      let(:params) { { attr => value } }
      let(:value) { 'pizza' }
      it { should == value }
    end
  end
end

