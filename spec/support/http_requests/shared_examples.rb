RSpec.shared_examples_for "an action that makes a request to Onfleet" do |path:, method:|
  let(:url) { URI.join(Onfleet.base_url, path).to_s }
  let(:response) { { status: 200, body: response_body.to_json } }
  before { stub_request(method, url).to_return(response) }

  it "should include the base64-encoded API key in the auth header" do
    encoded_api_key = Base64.urlsafe_encode64(Onfleet.api_key)

    subject.call
    expect(
      a_request(method, url).with(headers: { 'Authorization' => "Basic #{encoded_api_key}" })
    ).to have_been_made.once
  end

  it "should specify that it will accept JSON" do
    subject.call
    expect(
      a_request(method, url).with(headers: { 'Accept' => 'application/json' })
    ).to have_been_made.once
  end

  if %i[post put patch].include?(method.to_sym)
    it "should set the content type to JSON" do
      subject.call
      expect(
        a_request(method, url).with(headers: { 'Content-Type' => 'application/json' })
      ).to have_been_made.once
    end
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

RSpec.shared_examples_for Onfleet::Actions::Get do |path:|
  let(:response_body) { { id: 'an-object' } }
  it_should_behave_like "an action that makes a request to Onfleet", path: path, method: :get
end

RSpec.shared_examples_for Onfleet::Actions::List do |path:|
  let(:response_body) { [{ id: 'an-object' }, { id: 'another-object' }] }
  it_should_behave_like "an action that makes a request to Onfleet", path: path, method: :get
end

