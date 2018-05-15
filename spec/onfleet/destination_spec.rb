RSpec.describe Onfleet::Destination do
  let(:destination) { described_class.new(params) }
  let(:params) { { id: 'a-destination', address: address_params } }
  let(:address_params) { { street: '123 Main', city: 'Foo', state: 'TX' } }

  it_should_behave_like Onfleet::OnfleetObject

  describe ".create" do
    subject { -> { described_class.create(params) } }
    it_should_behave_like Onfleet::Actions::Create, path: 'destinations'
  end

  describe ".get" do
    subject { -> { described_class.get(id) } }
    let(:id) { 'a-destination' }
    it_should_behave_like Onfleet::Actions::Get, path: 'destinations/a-destination'
  end

  describe ".query_by_metadata" do
    subject { -> { described_class.query_by_metadata(metadata) } }
    let(:metadata) { [{ name: 'color', type: 'string', value: 'ochre' }] }
    it_should_behave_like Onfleet::Actions::QueryMetadata, path: 'destinations'
  end

  describe "#save" do
    subject { -> { destination.save } }

    context "with an ID attribute" do
      before { expect(params[:id]).to be }
      it_should_behave_like Onfleet::Actions::Update, path: 'destinations/a-destination'
    end

    context "without an ID attribute" do
      let(:params) { { address: address_params } }
      it_should_behave_like Onfleet::Actions::Create, path: 'destinations'
    end
  end

  describe "#address" do
    subject { destination.address }

    context "when initialized with address params" do
      let(:address_params) do
        {
          number: '123',
          street: 'Main St.',
          apartment: '',
          city: 'Foo',
          state: 'TX',
          postalCode: '99999',
          country: 'United States'
        }
      end
      its(:number) { should == '123' }
      its(:postal_code) { should == '99999' }
    end

    context "when initialized with no address params" do
      let(:address_params) { nil }
      it { should be_nil }
    end
  end
end

