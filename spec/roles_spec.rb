require 'spec_helper'

describe RoleModel::Roles do

  let(:model_instance) { Class.new.new }
  let(:array) { [:foo, :bar] }
  subject { RoleModel::Roles.new(model_instance, array) }

  its(:model_instance) { should equal(model_instance) }
  it { should include(:foo, :bar) }
  it { should respond_to(:each) }

  describe "#<<" do
    it "should add the given element to the model_instance.roles by re-assigning all roles" do
      model_instance.should_receive(:roles=).with(array_including(:foo, :bar, :baz))
      subject << :baz
    end
  end

  describe "#delete" do
    it "should delete the given element to the model_instance.roles by re-assigning all roles" do
      model_instance.should_receive(:roles=).with([:bar])
      subject.delete :foo
    end
  end
end
