require 'spec_helper'

describe RoleModel::Roles do

  let(:model_instance) { Class.new.new }
  let(:array) { [:foo, :bar] }
  subject { RoleModel::Roles.new(model_instance, array) }

  its(:model_instance) { should == model_instance }
  it { should include(:foo, :bar) }
  it { should be_kind_of(Array) }

  describe "#<<" do
    let(:roles_of_model_instance) { [:one, :two] }

    it "should add the given element to the model_instance.roles by re-assigning all roles" do
      model_instance.should_receive(:roles=).with([:foo, :bar, :baz])
      subject << :baz
    end
  end
end
