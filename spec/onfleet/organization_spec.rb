RSpec.describe Onfleet::Organization do
  let(:organization) { described_class.new(params) }
  let(:params) { { id: 'an-org' } }

  describe ".get" do
    subject { -> { described_class.get } }
    let(:url) { URI.join(Onfleet.base_url, 'organization').to_s }
    let(:response) { { status: 200, body: params.to_json } }
    before { stub_request(:get, url).to_return(response) }

    it "should include the base64-encoded API key in the auth header" do
      encoded_api_key = Base64.urlsafe_encode64(Onfleet.api_key)

      subject.call
      expect(
        a_request(:get, url).with(headers: { 'Authorization' => "Basic #{encoded_api_key}" })
      ).to have_been_made.once
    end

    it "should specify that it will accept JSON" do
      subject.call
      expect(
        a_request(:get, url).with(headers: { 'Accept' => 'application/json' })
      ).to have_been_made.once
    end

    context "without valid authentication" do
      let(:response) { { status: 401, body: { message: 'bad auth' }.to_json } }
      it { should raise_error(Onfleet::AuthenticationError) }
    end

    context "without valid authorization" do
      let(:response) { { status: 404, body: { message: 'bad auth' }.to_json } }
      it { should raise_error(Onfleet::InvalidRequestError) }
    end

    context "when an unspecified error occurs" do
      let(:response) { { status: 500, body: { message: 'all bad' }.to_json } }
      it { should raise_error(Onfleet::OnfleetError) }
    end
  end

  describe "#id" do
    subject { organization.id }
    it { should == params[:id] }
  end
end

