RSpec.describe Onfleet::Recipient do
  let(:recipient) { described_class.new(params) }
  let(:params) { { id: id, name: 'Recipient Jones' } }
  let(:id) { 'a-recipient' }

  it_should_behave_like Onfleet::OnfleetObject

  describe ".create" do
    subject { -> { described_class.create(params) } }
    it_should_behave_like Onfleet::Actions::Create, path: 'recipients'

    context "with the `skip_sms_notifications` attribute" do
      set_up_request_stub(:post, 'recipients')
      let(:params) { { skip_sms_notifications: true } }
      let(:response_body) { { id: 'an-object' } }

      it "should camelize the attribute name properly" do
        subject.call
        expect(
          a_request(:post, url).with(body: { 'skipSMSNotifications' => true }.to_json)
        ).to have_been_made.once
      end
    end
  end

  describe ".get" do
    subject { -> { described_class.get(id) } }
    it_should_behave_like Onfleet::Actions::Get, path: 'recipients/a-recipient'
  end

  describe ".update" do
    subject { -> { described_class.update(id, params) } }
    it_should_behave_like Onfleet::Actions::Update, path: 'recipients/a-recipient'

    context "with the `skip_sms_notifications` attribute" do
      set_up_request_stub(:put, 'recipients/a-recipient')
      let(:params) { { id: id, skip_sms_notifications: true } }
      let(:response_body) { { id: 'an-object' } }

      it "should camelize the attribute name properly" do
        subject.call
        expect(
          a_request(:put, url).with(body: { id: id, 'skipSMSNotifications' => true }.to_json)
        ).to have_been_made.once
      end
    end
  end

  describe ".find" do
    subject { -> { described_class.find(attribute, value) } }
    let(:attribute) { 'name' }
    let(:value) { 'Ma Bell' }
    it_should_behave_like Onfleet::Actions::Find, path: "recipients/name/Ma+Bell"
  end

  describe ".query_by_metadata" do
    subject { -> { described_class.query_by_metadata(metadata) } }
    let(:metadata) { [{ name: 'color', type: 'string', value: 'ochre' }] }
    it_should_behave_like Onfleet::Actions::QueryMetadata, path: 'recipients'
  end

  describe "#save" do
    subject { -> { recipient.save } }

    context "with an ID attribute" do
      before { expect(params[:id]).to be }
      it_should_behave_like Onfleet::Actions::Update, path: 'recipients/a-recipient'
    end

    context "without an ID attribute" do
      let(:params) { { name: 'Recipient Jones' } }
      it_should_behave_like Onfleet::Actions::Create, path: 'recipients'
    end
  end
end

