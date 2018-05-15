RSpec.describe Onfleet::Webhook do
  let(:webhook) { described_class.new(params) }
  let(:params) { { id: 'a-webhook', url: 'https://example.com', is_enabled: true } }

  it_should_behave_like Onfleet::OnfleetObject

  describe ".list" do
    subject { -> { described_class.list(query_params) } }

    context "with no filter" do
      let(:query_params) { nil }
      it_should_behave_like Onfleet::Actions::List, path: 'webhooks'
    end

    context "with query params" do
      let(:query_params) { { food: 'pizza', topping: 'mushroom' } }
      it_should_behave_like Onfleet::Actions::List, path: 'webhooks?food=pizza&topping=mushroom'
    end

    context "with a URL-unsafe query param" do
      let(:query_params) { { food: 'green eggs & ham' } }
      it_should_behave_like Onfleet::Actions::List, path: 'webhooks?food=green+eggs+%26+ham'
    end
  end

  describe ".create" do
    subject { -> { described_class.create(params) } }
    it_should_behave_like Onfleet::Actions::Create, path: 'webhooks'
  end

  describe ".delete" do
    subject { -> { described_class.delete(id) } }
    let(:id) { 'a-webhook' }
    it_should_behave_like Onfleet::Actions::Delete, path: 'webhooks/a-webhook'
  end

  describe "#save" do
    subject { -> { webhook.save } }

    context "with an ID attribute" do
      before { expect(params[:id]).to be }
      it_should_behave_like Onfleet::Actions::Update, path: 'webhooks/a-webhook'
    end

    context "without an ID attribute" do
      let(:params) { { name: 'An Webhook' } }
      it_should_behave_like Onfleet::Actions::Create, path: 'webhooks'
    end
  end
end

