RSpec.describe Onfleet::Task do
  let(:task) { described_class.new(params) }
  let(:params) { { id: id, short_id: 'at', destination: 'a-destination', recipients: ['jeff'] } }
  let(:id) { 'a-task' }

  it_should_behave_like Onfleet::OnfleetObject

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
        subject.call
        expect(
          a_request(:post, url).with(body: {
            recipientSkipSMSNotifications: true,
            destination: nil,
            recipients: []
          }.to_json)
        ).to have_been_made.once
      end
    end

    context "with barcode attributes" do
      set_up_request_stub(:post, 'tasks')
      let(:params) { { barcodes: [{ data: 'abc', block_completion: true }] } }
      let(:response_body) { { id: 'an-object' } }

      it "should camelize the attribute name properly" do
        subject.call
        expect(
          a_request(:post, url).with(body: {
            barcodes: [{ data: 'abc', 'blockCompletion' => true }],
            destination: nil,
            recipients: []
          }.to_json)
        ).to have_been_made.once
      end
    end
  end

  describe ".get" do
    subject { -> { described_class.get(id) } }
    it_should_behave_like Onfleet::Actions::Get, path: 'tasks/a-task'
  end

  describe ".update" do
    subject { -> { described_class.update(id, params) } }
    it_should_behave_like Onfleet::Actions::Update, path: 'tasks/a-task'

    context "with the skip_sms_notification override attribute" do
      set_up_request_stub(:put, 'tasks/a-task')
      let(:params) { { id: id, recipient_skip_sms_notifications: true } }
      let(:response_body) { { id: 'an-object' } }

      it "should camelize the attribute name properly" do
        subject.call
        expect(
          a_request(:put, url).with(body: {
            id: id,
            recipientSkipSMSNotifications: true,
            destination: nil,
            recipients: []
          }.to_json)
        ).to have_been_made.once
      end
    end

    context "with barcode attributes" do
      set_up_request_stub(:put, 'tasks/a-task')
      let(:params) { { id: id, barcodes: [{ data: 'abc', block_completion: true }] } }
      let(:response_body) { { id: 'an-object' } }

      it "should camelize the attribute name properly" do
        subject.call
        expect(
          a_request(:put, url).with(body: {
            id: id,
            barcodes: [{ data: 'abc', 'blockCompletion' => true }],
            destination: nil,
            recipients: []
          }.to_json)
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
      let(:params) { { short_id: 'at', destination: 'a-destination', recipients: ['jeff'] } }
      it_should_behave_like Onfleet::Actions::Create, path: 'tasks'
    end
  end

  describe "#destination" do
    subject { task.destination }

    context "when initialized with destination params" do
      let(:params) { { destination: destination_params } }
      let(:destination_params) { { location: [-107, 44] } }
      its(:location) { should == destination_params[:location] }
    end

    context "when initialized with no destination params" do
      let(:params) { { destination: nil } }
      it { should be_nil }
    end
  end

  describe "#destination=" do
    subject { -> { task.destination = destination } }
    let(:task) { described_class.new }
    let(:destination_params) { { location: [-107, 44] } }

    context "with an Destination object" do
      let(:destination) { Onfleet::Destination.new(destination_params) }
      it { should change(task, :destination).from(nil).to(destination) }
    end

    context "with a hash of destination params" do
      let(:destination) { destination_params }
      it { should change(task, :destination).from(nil).to be_kind_of(Onfleet::Destination) }
    end

    context "with nil" do
      let(:destination) { nil }
      before { task.destination = destination_params }
      it { should change(task, :destination).to be_nil }
    end
  end

  describe "#recipients" do
    subject { task.recipients }

    context "when initialized with recipients params" do
      let(:params) { { recipients: [{ name: 'Leia' }, { name: 'Han' }] } }
      its(:size) { should == params[:recipients].size }
      its('first.name') { should == 'Leia' }
    end

    context "when initialized with no recipients params" do
      let(:params) { {} }
      it { should be_empty }
    end
  end

  describe "#recipients=" do
    subject { -> { task.recipients = recipients } }
    let(:recipient) { described_class.new }
    let(:task) { described_class.new }

    context "with an array of Recipient objects" do
      let(:recipients) { [Onfleet::Recipient.new(name: 'Chewy')] }
      it { should change(task, :recipients).from([]).to(recipients) }
    end

    context "with an array that contains a hash of recipient params" do
      let(:recipients) { [{ name: 'Chewy' }] }
      it { should change { task.recipients.first }.from(nil).to be_kind_of(Onfleet::Recipient) }
    end
  end

  describe "#barcodes" do
    subject { task.barcodes }

    context "when initialized with barcodes params" do
      let(:params) { { barcodes: [{ data: 'foo' }, { data: 'bar' }] } }
      its(:size) { should == params[:barcodes].size }
      its('first.data') { should == 'foo' }
    end

    context "when initialized with no barcodes params" do
      let(:params) { {} }
      it { should be_empty }
    end
  end

  describe "#barcodes=" do
    subject { -> { task.barcodes = barcodes } }
    let(:barcode) { described_class.new }
    let(:task) { described_class.new }

    context "with an array of Barcode objects" do
      let(:barcodes) { [Onfleet::Barcode.new(data: 'foo')] }
      it { should change(task, :barcodes).from([]).to(barcodes) }
    end

    context "with an array that contains a hash of barcode params" do
      let(:barcodes) { [{ data: 'foo' }] }
      it { should change { task.barcodes.first }.from(nil).to be_kind_of(Onfleet::Barcode) }
    end
  end

  describe "#as_json" do
    subject { task.as_json }

    its(['id']) { should == params[:id] }
    its(['shortId']) { should == params[:short_id] }

    context "with a destination" do
      let(:params) { { destination: Onfleet::Destination.new(id: 'a-destination') } }
      its(['destination']) { should == 'a-destination' }
    end

    context "with recipients" do
      let(:params) { { recipients: [{ id: 'a-recipient' }, { id: 'another-recipient' }] } }
      its(['recipients']) { should == ['a-recipient', 'another-recipient'] }
    end
  end
end

