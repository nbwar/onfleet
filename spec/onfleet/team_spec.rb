RSpec.describe Onfleet::Team do
  let(:team) { described_class.new(params) }
  let(:params) { { id: 'a-team', name: 'Detroit Redwings' } }

  it_should_behave_like Onfleet::OnfleetObject

  describe ".list" do
    subject { -> { described_class.list(query_params) } }

    context "with no filter" do
      let(:query_params) { nil }
      it_should_behave_like Onfleet::Actions::List, path: 'teams'
    end

    context "with query params" do
      let(:query_params) { { food: 'pizza', topping: 'mushroom' } }
      it_should_behave_like Onfleet::Actions::List, path: 'teams?food=pizza&topping=mushroom'
    end

    context "with a URL-unsafe query param" do
      let(:query_params) { { food: 'green eggs & ham' } }
      it_should_behave_like Onfleet::Actions::List, path: 'teams?food=green+eggs+%26+ham'
    end
  end

  describe ".get" do
    subject { -> { described_class.get(id) } }
    let(:id) { 'a-team' }
    it_should_behave_like Onfleet::Actions::Get, path: 'teams/a-team'
  end

  describe "#tasks" do
    subject { team.tasks }

    context "when initialized with vehicle params" do
      let(:params) { { tasks: tasks_params } }
      let(:tasks_params) { [{ team: 'xavier' }, { team: 'francine' }] }
      its(:size) { should == tasks_params.size }
      it { should be_all { |task| task.is_a?(Onfleet::Task) } }
    end

    context "when initialized with no task params" do
      let(:tasks_params) { nil }
      it { should be_empty }
    end
  end

  describe "#tasks=" do
    subject { -> { team.tasks = tasks } }
    let(:task) { described_class.new }

    context "with an array of Task objects" do
      let(:tasks) { [Onfleet::Task.new(worker: 'Leia')] }
      it { should change(team, :tasks).from([]).to(tasks) }
    end

    context "with an array that contains a hash of task params" do
      let(:tasks) { [{ worker: 'Leia' }] }
      it { should change { team.tasks.first }.from(nil).to be_kind_of(Onfleet::Task) }
    end
  end
end

