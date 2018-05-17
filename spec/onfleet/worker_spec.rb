RSpec.describe Onfleet::Worker do
  let(:worker) { described_class.new(params) }
  let(:params) { { id: id, name: 'F. Prefect', phone: '5551212', tasks: [] } }
  let(:id) { 'a-worker' }

  it_should_behave_like Onfleet::OnfleetObject

  describe ".list" do
    subject { -> { described_class.list(query_params) } }

    context "with no filter" do
      let(:query_params) { nil }
      it_should_behave_like Onfleet::Actions::List, path: 'workers'
    end

    context "with query params" do
      let(:query_params) { { food: 'pizza', topping: 'mushroom' } }
      it_should_behave_like Onfleet::Actions::List, path: 'workers?food=pizza&topping=mushroom'
    end

    context "with a URL-unsafe query param" do
      let(:query_params) { { food: 'green eggs & ham' } }
      it_should_behave_like Onfleet::Actions::List, path: 'workers?food=green+eggs+%26+ham'
    end
  end

  describe ".create" do
    subject { -> { described_class.create(params) } }
    it_should_behave_like Onfleet::Actions::Create, path: 'workers'
  end

  describe ".get" do
    subject { -> { described_class.get(id) } }
    it_should_behave_like Onfleet::Actions::Get, path: 'workers/a-worker'
  end

  describe ".update" do
    subject { -> { described_class.update(id, params) } }
    it_should_behave_like Onfleet::Actions::Update, path: 'workers/a-worker'
  end

  describe ".delete" do
    subject { -> { described_class.delete(id) } }
    it_should_behave_like Onfleet::Actions::Delete, path: 'workers/a-worker'
  end

  describe ".query_by_metadata" do
    subject { -> { described_class.query_by_metadata(metadata) } }
    let(:metadata) { [{ name: 'color', type: 'string', value: 'ochre' }] }
    it_should_behave_like Onfleet::Actions::QueryMetadata, path: 'workers'
  end

  describe "#save" do
    subject { -> { worker.save } }

    context "with an ID attribute" do
      before { expect(params[:id]).to be }
      it_should_behave_like Onfleet::Actions::Update, path: 'workers/a-worker'
    end

    context "without an ID attribute" do
      let(:params) { { name: 'A Worker', tasks: [] } }
      it_should_behave_like Onfleet::Actions::Create, path: 'workers'
    end
  end

  describe "#vehicle" do
    subject { worker.vehicle }

    context "when initialized with vehicle params" do
      let(:params) { { vehicle: vehicle_params } }
      let(:vehicle_params) { { type: 'TRUCK', description: 'Oscar Meyer Weinermobile' } }
      its(:type) { should == vehicle_params[:type] }
      its(:description) { should == vehicle_params[:description] }
    end

    context "when initialized with no vehicle params" do
      let(:vehicle_params) { nil }
      it { should be_nil }
    end
  end

  describe "#vehicle=" do
    subject { -> { worker.vehicle = vehicle } }
    let(:worker) { described_class.new }
    let(:vehicle_params) { { type: 'CAR', description: 'The Batmobile' } }

    context "with an Vehicle object" do
      let(:vehicle) { Onfleet::Vehicle.new(vehicle_params) }
      it { should change(worker, :vehicle).from(nil).to(vehicle) }
    end

    context "with a hash of vehicle params" do
      let(:vehicle) { vehicle_params }
      it { should change(worker, :vehicle).from(nil).to be_kind_of(Onfleet::Vehicle) }
    end

    context "with nil" do
      let(:vehicle) { nil }
      before { worker.vehicle = vehicle_params }
      it { should change(worker, :vehicle).to be_nil }
    end
  end

  describe "#tasks" do
    subject { worker.tasks }

    context "when initialized with vehicle params" do
      let(:params) { { tasks: tasks_params } }
      let(:tasks_params) { [{ worker: 'xavier' }, { worker: 'francine' }] }
      its(:size) { should == tasks_params.size }
      it { should be_all { |task| task.is_a?(Onfleet::Task) } }
    end

    context "when initialized with no task params" do
      let(:tasks_params) { nil }
      it { should be_empty }
    end
  end

  describe "#tasks=" do
    subject { -> { worker.tasks = tasks } }
    let(:task) { described_class.new }

    context "with an array of Task objects" do
      let(:tasks) { [Onfleet::Task.new(worker: 'Leia')] }
      it { should change(worker, :tasks).from([]).to(tasks) }
    end

    context "with an array that contains a hash of task params" do
      let(:tasks) { [{ worker: 'Leia' }] }
      it { should change { worker.tasks.first }.from(nil).to be_kind_of(Onfleet::Task) }
    end
  end

  describe "#as_json" do
    subject { worker.as_json }

    its(['id']) { should == params[:id] }

    context "with a vehicle" do
      let(:params) { { vehicle: Onfleet::Vehicle.new(vehicle_params) } }
      let(:vehicle_params) { { type: 'BICYCLE', description: 'Unicycle', license_plate: 'CLWNSRUL' } }

      it "should include the full vehicle attributes" do
        expect(subject['vehicle']['type']).to eq(vehicle_params[:type])
        expect(subject['vehicle']['description']).to eq(vehicle_params[:description])
        expect(subject['vehicle']['licensePlate']).to eq(vehicle_params[:license_plate])
      end
    end

    context "with tasks" do
      let(:params) { { tasks: [{ id: 'a-task' }, { id: 'another-task' }] } }
      its(['tasks']) { should == ['a-task', 'another-task'] }
    end
  end
end

