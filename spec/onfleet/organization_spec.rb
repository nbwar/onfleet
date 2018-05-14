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

  %i[id name email country timezone time_created time_last_modified].each do |attr|
    describe "##{attr}" do
      subject { organization.public_send(attr) }
      let(:params) { { attr => value } }
      let(:value) { 'pizza' }
      it { should == value }
    end
  end
end

