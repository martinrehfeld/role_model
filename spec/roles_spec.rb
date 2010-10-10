require 'spec_helper'

describe RoleModel::Roles do

  let(:model_instance) { Class.new.new }
  let(:array) { [:foo, :bar] }
  subject { RoleModel::Roles.new(model_instance, array) }
  before(:each) do
    model_instance.stub(:roles=)
  end

  its(:model_instance) { should equal(model_instance) }
  it { should include(:foo, :bar) }
  it { should respond_to(:each) }

  describe "#<<" do
    it "should add the given element to the model_instance.roles by re-assigning all roles" do
      model_instance.should_receive(:roles=).with(array_including(:foo, :bar, :baz))
      subject << :baz
    end
  end

  describe "#add" do
    it "should add the given element to the model_instance.roles by re-assigning all roles" do
      model_instance.should_receive(:roles=).with(array_including(:foo, :bar, :baz))
      subject.add(:baz)
    end
  end

  describe "#merge" do
    it "should add the given enum to the model_instance.roles by re-assigning all roles" do
      model_instance.should_receive(:roles=).with(array_including(:foo, :bar, :baz, :quux))
      subject.merge([:baz, :quux])
    end
  end

  describe "#delete" do
    it "should delete the given element to the model_instance.roles by re-assigning all roles" do
      model_instance.should_receive(:roles=).with(subject)
      subject.delete :foo
      subject.should_not include(:foo)
    end
  end

  describe "#subtract" do
    it "should remove the given enum to the model_instance.roles by re-assigning all roles" do
      model_instance.should_receive(:roles=).with(subject)
      subject.subtract([:foo, :bar])
      subject.should have(0).roles
    end
  end
end
