RSpec.describe Onfleet::Destination do
  let(:destination) { described_class.new(params) }
  let(:params) { { id: id, address: address_params } }
  let(:id) { 'a-destination' }
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

  describe "#address=" do
    subject { -> { destination.address = address } }
    let(:destination) { described_class.new }

    context "with an Address object" do
      let(:address) { Onfleet::Address.new(address_params) }
      it { should change(destination, :address).from(nil).to(address) }
    end

    context "with a hash of address params" do
      let(:address) { address_params }
      it { should change(destination, :address).from(nil).to be_kind_of(Onfleet::Address) }
    end
  end

  describe "#as_json" do
    subject { destination.as_json }

    its(['id']) { should == params[:id] }

    context "with an address" do
      let(:params) { { address: Onfleet::Address.new(address_params) } }
      let(:address_params) { { street: 'Main St', postal_code: '99999' } }

      it "should include the full address attributes" do
        expect(subject['address']['street']).to eq(address_params[:street])
        expect(subject['address']['postalCode']).to eq(address_params[:postal_code])
      end
    end
  end
end

