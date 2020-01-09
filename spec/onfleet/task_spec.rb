RSpec.describe Onfleet::Task do
  let(:task) { described_class.new(params) }
  let(:params) { { id: 'a-task', short_id: 'at', recipients: ['jeff'] } }

  describe ".list" do
    subject { -> { described_class.list(query_params) } }

    context "with no filter" do
      let(:query_params) { nil }
      it_should_behave_like Onfleet::Actions::List, path: 'tasks'
    end

    context "with query params" do
      let(:query_params) { { food: 'pizza', topping: 'mushroom' } }
      it_should_behave_like Onfleet::Actions::List, path: 'tasks?food=pizza&topping=mushroom'
    end

    context "with a URL-unsafe query param" do
      let(:query_params) { { food: 'green eggs & ham' } }
      it_should_behave_like Onfleet::Actions::List, path: 'tasks?food=green+eggs+%26+ham'
    end
  end

  describe ".create" do
    subject { -> { described_class.create(params) } }
    it_should_behave_like Onfleet::Actions::Create, path: 'tasks'

    context "with the skip_sms_notification override attribute" do
      set_up_request_stub(:post, 'tasks')
      let(:params) { { recipient_skip_sms_notifications: true } }
      let(:response_body) { { id: 'an-object' } }

      it "should camelize the attribute name properly" do
        pending('The SMS acronym does not camelize consistently')
        subject.call
        expect(
          a_request(:post, url).with(body: { recipientSkipSMSNotifications: true }.to_json)
        ).to have_been_made.once
      end
    end

    context "with barcode attributes" do
      set_up_request_stub(:post, 'tasks')
      let(:params) { { barcodes: [{ data: 'abc', block_completion: true }] } }
      let(:response_body) { { id: 'an-object' } }

      it "should camelize the attribute name properly" do
        pending('JSON subkeys of non-Onfleet objects do not camelize')
        subject.call
        expect(
          a_request(:post, url).with(body: { barcodes: [{ data: 'abc', 'blockCompletion' => true }] }.to_json)
        ).to have_been_made.once
      end
    end
  end

  describe ".get" do
    subject { -> { described_class.get(id) } }
    let(:id) { 'a-task' }
    it_should_behave_like Onfleet::Actions::Get, path: 'tasks/a-task'
  end

  describe ".short_get" do
    subject { -> { described_class.short_get(id) } }
    let(:id) { 'a-task' }
    it_should_behave_like(
      Onfleet::Actions::ShortGet,
      path: 'tasks/short/a-task'
    )
  end

  describe ".update" do
    subject { -> { described_class.update(id, params) } }
    let(:id) { 'a-task' }
    it_should_behave_like Onfleet::Actions::Update, path: 'tasks/a-task'

    context "with the skip_sms_notification override attribute" do
      set_up_request_stub(:put, 'tasks/a-task')
      let(:params) { { id: 'a-task', recipient_skip_sms_notifications: true } }
      let(:response_body) { { id: 'an-object' } }

      it "should camelize the attribute name properly" do
        pending('The SMS acronym does not camelize consistently')
        subject.call
        expect(
          a_request(:put, url).with(body: { recipientSkipSMSNotifications: true }.to_json)
        ).to have_been_made.once
      end
    end

    context "with barcode attributes" do
      set_up_request_stub(:put, 'tasks/a-task')
      let(:params) { { id: 'a-task', barcodes: [{ data: 'abc', block_completion: true }] } }
      let(:response_body) { { id: 'an-object' } }

      it "should camelize the attribute name properly" do
        pending('JSON subkeys of non-Onfleet objects do not camelize')
        subject.call
        expect(
          a_request(:put, url).with(body: { barcodes: [{ data: 'abc', 'blockCompletion' => true }] }.to_json)
        ).to have_been_made.once
      end
    end
  end

  describe ".delete" do
    subject { -> { described_class.delete(id) } }
    let(:id) { 'an-task' }
    it_should_behave_like Onfleet::Actions::Delete, path: 'tasks/an-task'
  end

  describe ".query_by_metadata" do
    subject { -> { described_class.query_by_metadata(metadata) } }
    let(:metadata) { [{ name: 'color', type: 'string', value: 'ochre' }] }
    it_should_behave_like Onfleet::Actions::QueryMetadata, path: 'tasks'
  end

  describe "#save" do
    subject { -> { task.save } }

    context "with an ID attribute" do
      before { expect(params[:id]).to be }
      it_should_behave_like Onfleet::Actions::Update, path: 'tasks/a-task'
    end

    context "without an ID attribute" do
      let(:params) { { short_id: 'at', recipients: ['jeff'] } }
      it_should_behave_like Onfleet::Actions::Create, path: 'tasks'
    end
  end
end
