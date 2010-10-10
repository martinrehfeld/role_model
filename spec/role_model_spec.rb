require 'spec_helper'

describe RoleModel do

  let(:model_class) { Class.new }

  before(:each) do
    model_class.instance_eval do
      attr_accessor :roles_mask
      attr_accessor :custom_roles_mask
      include RoleModel
      roles :foo, :bar, :third
    end
  end

  [:roles_attribute, :roles_attribute=].each do |roles_attribute_setter_method|
    describe ".#{roles_attribute_setter_method}" do
      before(:each) do
        model_class.instance_eval do
          send(roles_attribute_setter_method, :custom_roles_mask)
          roles :sample
        end
      end
      subject { model_class.new }

      it "should change the bitmask attribute used to store the assigned roles" do
        subject.roles = [:sample]
        subject.roles_mask.should be_nil
        subject.custom_roles_mask.should == 1
      end
    end
  end

  describe ".roles" do
    subject { model_class.new }

    it "should define the valid roles" do
      subject.roles = %w(foo bar baz)
      subject.roles.should include(:foo, :bar)
      subject.roles.should_not include(:baz)
    end

    it "should define the bitvalue of each role by position" do
      subject.roles = :foo
      subject.roles_mask.should == 1
      subject.roles = :bar
      subject.roles_mask.should == 2
    end
  end

  [:roles, :role_symbols].each do |role_query_method|
    describe "##{role_query_method}" do
      subject { model_class.new }

      it "should return the assigned roles as symbols" do
        subject.roles = [:foo, :bar]
        subject.send(role_query_method).should include(:foo, :bar)
        subject.send(role_query_method).should have(2).elements
      end

      it "should return an empty array when no roles have been assigned" do
        subject.send(role_query_method).should be_empty
      end
    end
  end

  describe "#roles=" do
    subject { model_class.new }

    it "should accept an array of symbols" do
      subject.roles = [:foo, :bar]
      subject.roles.should include(:foo, :bar)
      subject.should have(2).roles
      subject.roles = [:bar]
      subject.roles.should include(:bar)
      subject.should have(1).roles
    end

    it "should accept an array of strings" do
      subject.roles = %w(foo bar)
      subject.roles.should include(:foo, :bar)
      subject.should have(2).roles
      subject.roles = ['bar']
      subject.roles.should include(:bar)
      subject.should have(1).roles
    end

    it "should accept a single symbol" do
      subject.roles = :foo
      subject.roles.should include(:foo)
      subject.should have(1).roles
    end

    it "should accept a single string" do
      subject.roles = 'foo'
      subject.roles.should include(:foo)
      subject.should have(1).roles
    end

    it "should accept multiple arguments as symbols" do
      subject.send(:roles=, :foo, :bar)
      subject.roles.should include(:foo, :bar)
      subject.should have(2).roles
    end

    it "should accept multiple arguments as strings" do
      subject.send(:roles=, 'foo', 'bar')
      subject.roles.should include(:foo, :bar)
      subject.should have(2).roles
    end

    it "should silently ignore undefined roles" do
      subject.roles = :baz
      subject.roles.should be_empty
    end

    context "with previouly assigned roles" do
      before(:each) do
        subject.roles = :foo
        subject.roles.should include(:foo)
        subject.should have(1).roles
      end

      it "should set set assigned roles regardless overwriting previouly assigned roles" do
        subject.roles = :bar
        subject.roles.should include(:bar)
        subject.should have(1).roles
      end

      it "should allow reassigning the #roles value aka Roles object" do
        subject.roles << :bar
        subject.roles = subject.roles
        subject.roles.should include(:foo, :bar)
        subject.should have(2).roles
      end
    end
  end

  describe "#<<" do
    subject { model_class.new }

    context "with roles :foo and :bar already assigned" do
      before(:each) do
        subject.roles = [:foo, :bar]
      end

      it "should add a role given as a symbol" do
        subject.roles << :third
        subject.roles.should include(:foo, :bar, :third)
        subject.should have(3).roles
      end

      it "should add a role given as a string" do
        subject.roles << 'third'
        subject.roles.should include(:foo, :bar, :third)
        subject.should have(3).roles
      end

      it "should not show a role twice in the return value" do
        (subject.roles << :foo).should have(2).roles
      end
    end

    context "without any previouly assigned roles" do
      it "should add a single symbol" do
        subject.roles << :foo
        subject.roles.should include(:foo)
        subject.should have(1).roles
      end

      it "should add a single string" do
        subject.roles << 'foo'
        subject.roles.should include(:foo)
        subject.should have(1).roles
      end

      it "should allow chaining of <<" do
        subject.roles << :foo << :bar
        subject.roles.should include(:foo, :bar)
        subject.should have(2).roles
      end

      it "should silently ignore undefined roles" do
        subject.roles << :baz
        subject.roles.should be_empty
      end
    end
  end

  describe "#delete" do
    subject { model_class.new }

    context "with roles :foo and :bar already assigned" do
      before(:each) do
        subject.roles = [:foo, :bar]
      end

      it "should delete a existing role given as a symbol" do
        subject.roles.delete(:foo)
        subject.roles.should_not include(:foo)
        subject.should have(1).roles
      end

      it "should delete a existing role given as a string" do
        subject.roles.delete('foo')
        subject.roles.should_not include(:foo)
        subject.should have(1).roles
      end

      it "should not change anything if a non existing role is given" do
        subject.roles.delete(:third)
        subject.roles.should include(:foo, :bar)
        subject.should have(2).roles
      end
    end
    
    context "without roles assigned" do
      it "should have 0 roles if a role is given as a symbol" do
        subject.roles.delete(:foo)
        subject.should have(0).roles
      end

      it "should have 0 roles if a role is given as a string" do
        subject.roles.delete('foo')
        subject.should have(0).roles
      end
    end

  end

  context "query for an individual role" do
    [:has_any_role?, :is_any_of?, :has_role?, :has_all_roles?, :is?, :has_roles?].each do |check_role_assignment_method|
      describe "##{check_role_assignment_method}" do
        subject { model_class.new }

        it "should return true when the given role was assigned" do
          subject.roles = :foo
          subject.send(check_role_assignment_method, :foo).should be_true
        end

        it "should return false when the given role was not assigned" do
          subject.roles = :bar
          subject.send(check_role_assignment_method, :foo).should be_false
        end

        it "should return false when no role was assigned" do
          subject.send(check_role_assignment_method, :foo).should be_false
          subject.send(check_role_assignment_method, :bar).should be_false
        end

        it "should return false when asked for an undefined role" do
          subject.send(check_role_assignment_method, :baz).should be_false
        end
      end
    end
  end

  context "query for multiple roles" do
    [:has_any_role?, :is_any_of?, :has_role?].each do |check_role_assignment_method|
      describe "##{check_role_assignment_method}" do
        subject { model_class.new }

        it "should return true when any of the given roles was assigned" do
          subject.roles = [:foo, :baz]
          subject.send(check_role_assignment_method, :foo, :bar).should be_true
        end

        it "should return false when none of the given roles were assigned" do
          subject.roles = [:foo, :bar]
          subject.send(check_role_assignment_method, :baz, :quux).should be_false
        end
      end
    end

    [:has_all_roles?, :is?, :has_roles?].each do |check_role_assignment_method|
      describe "##{check_role_assignment_method}" do
        subject { model_class.new }

        it "should return true when all of the given roles were assigned" do
          subject.roles = [:foo, :bar]
          subject.send(check_role_assignment_method, :foo, :bar).should be_true
        end

        it "should return false when only some of the given roles were assigned" do
          subject.roles = [:foo, :bar]
          subject.send(check_role_assignment_method, :bar, :baz).should be_false
        end

        it "should return false when none of the given roles were assigned" do
          subject.roles = [:foo, :bar]
          subject.send(check_role_assignment_method, :baz, :quux).should be_false
        end
      end
    end
  end

  context "inheritance" do
    let(:superclass_instance) {  model_class.new }
    let(:inherited_model_class) { Class.new(model_class) }
    subject { inherited_model_class.new }

    it "should not alter the superclass behaviour" do
      inherited_model_class.instance_eval do
        roles :quux, :quuux
      end
      superclass_instance.roles = [:foo, :bar, :quux, :quuux]
      superclass_instance.roles.should include(:foo, :bar)
      superclass_instance.roles.should have(2).roles
    end

    it "should inherit the valid roles" do
      subject.roles = [:foo, :bar, :quux, :quuux]
      subject.roles.should include(:foo, :bar)
      subject.should have(2).roles
    end

    it "should not inherit the assigned roles" do
      subject.roles.should be_empty
    end

    it "should allow overriding the valid roles for the inherited class" do
      inherited_model_class.instance_eval do
        roles :quux, :quuux
      end
      subject.roles = [:foo, :bar, :quux, :quuux]
      subject.roles.should include(:quux, :quuux)
      subject.should have(2).roles
      subject.roles_mask.should == 3
    end

    it "should allow overriding the attribute to store the roles for the inherited class" do
      inherited_model_class.instance_eval do
        roles_attribute :custom_roles_mask
      end
      subject.roles = [:foo, :bar, :quux, :quuux]
      subject.roles.should include(:foo, :bar)
      subject.should have(2).roles
      subject.custom_roles_mask.should == 3
    end
  end

  context "independent usage" do
    let(:model_instance) {  model_class.new }
    let(:other_model_class) { Class.new }
    before(:each) do
      other_model_class.instance_eval do
        attr_accessor :roles_mask
        include RoleModel
        roles :quux, :quuux
      end
    end
    subject { other_model_class.new }

    it "should not alter the behaviour of other classes" do
      model_instance.roles = [:foo, :bar, :quux, :quuux]
      model_instance.roles.should include(:foo)
      model_instance.roles.should include(:bar)
      model_instance.should have(2).roles
    end

    it "should allow using different roles in other models" do
      subject.roles = [:foo, :bar, :quux, :quuux]
      subject.roles.should include(:quux)
      subject.roles.should include(:quuux)
      subject.should have(2).roles
    end
  end

  describe ".mask_for" do
    subject { model_class.new }

    before(:each) do
      model_class.instance_eval do
        attr_accessor :roles_mask
        attr_accessor :custom_roles_mask
        include RoleModel
        roles :foo, :bar, :third
      end
    end

    context "passing" do
      it "should return the role mask of a role" do
        subject.class.mask_for(:foo).should == 1
        subject.class.mask_for(:bar).should == 2
        subject.class.mask_for(:third).should == 4
      end

      it "should return the role mask of an array of roles" do
        subject.class.mask_for(:foo, :bar).should == 3
        subject.class.mask_for(:foo, :third).should == 5
        subject.class.mask_for(:foo, :bar, :third).should == 7
      end

      it "should return the role mask of a string array of roles" do
        subject.class.mask_for("foo").should == 1
        subject.class.mask_for("foo", "bar").should == 3
        subject.class.mask_for("foo", "third").should == 5
      end

      it "should return the role mask of the existing roles" do
        subject.class.mask_for(:foo, :quux).should == 1
      end

      it "should return 0 when a role that does not exist is passed" do
        subject.class.mask_for(:quux).should == 0
      end
    end
  end

end
