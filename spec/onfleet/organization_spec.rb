RSpec.describe Onfleet::Organization do
  let(:organization) { described_class.new(params) }
  let(:params) { { id: 'an-org' } }

  describe ".get" do
    subject { -> { described_class.get } }
    it_should_behave_like "an action that makes a request to Onfleet", path: 'organization'
  end

  describe ".get_delegatee_details" do
    subject { -> { described_class.get_delegatee_details(id) } }
    let(:id) { 'my-org' }
    it_should_behave_like "an action that makes a request to Onfleet", path: 'organizations/my-org'
  end

  describe "#id" do
    subject { organization.id }
    it { should == params[:id] }
  end
end

