RSpec.shared_examples_for Onfleet::Base do
  describe "#initialize" do
    subject { described_class.new(param) }
    let(:id) { 'an-object' }

    context "with a hash param" do
      let(:param) { { id: id, name: 'Slartibartfast' } }
      its(:id) { should == id }
    end

    context "with a string param" do
      let(:param) { id }
      its(:id) { should == id }
    end

    context "with no param" do
      let(:param) { nil }
      its(:id) { should be_nil }
    end
  end
end

