require 'spec_helper'

describe RoleModel do

  let(:model_class) { Class.new }

  before(:each) do
    model_class.instance_eval do
      attr_accessor :roles_mask
      attr_accessor :custom_roles_mask
      include RoleModel
      roles :foo, :bar
    end
  end

  describe ".roles_attribute" do
    before(:each) do
      model_class.instance_eval do
        roles_attribute :custom_roles_mask
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

  describe ".roles" do
    subject { model_class.new }

    it "should define the valid roles" do
      subject.roles = %w(foo bar baz)
      subject.roles.should include(:foo)
      subject.roles.should include(:bar)
      subject.roles.should_not include(:baz)
    end

    it "should define the bitvalue of each role by position" do
      subject.roles = :foo
      subject.roles_mask.should == 1
      subject.roles = :bar
      subject.roles_mask.should == 2
    end
  end

  describe "#roles" do
    subject { model_class.new }

    it "should return the assigned roles as symbols" do
      subject.roles = [:foo, :bar]
      subject.roles.should include(:foo)
      subject.roles.should include(:bar)
      subject.roles.should have(2).elements
    end

    it "should return an empty array when no roles have been assigned" do
      subject.roles.should be_empty
    end
  end

  describe "#role_symbols" do
    subject { model_class.new }

    it "should be an alias to roles" do
      subject.method(:role_symbols).should == subject.method(:roles)
    end
  end

  describe "#roles=" do
    subject { model_class.new }

    it "should accept an array of symbols" do
      subject.roles = [:foo, :bar]
      subject.roles.should include(:foo)
      subject.roles.should include(:bar)
      subject.roles.should have(2).elements
      subject.roles = [:bar]
      subject.roles.should include(:bar)
      subject.roles.should have(1).element
    end

    it "should accept an array of strings" do
      subject.roles = %w(foo bar)
      subject.roles.should include(:foo)
      subject.roles.should include(:bar)
      subject.roles.should have(2).elements
      subject.roles = ['bar']
      subject.roles.should include(:bar)
      subject.roles.should have(1).element
    end

    it "should accept a single symbol" do
      subject.roles = :foo
      subject.roles.should include(:foo)
      subject.roles.should have(1).element
    end

    it "should accept a single string" do
      subject.roles = 'foo'
      subject.roles.should include(:foo)
      subject.roles.should have(1).element
    end

    it "should accept multiple arguments as symbols" do
      subject.send(:roles=, :foo, :bar)
      subject.roles.should include(:foo)
      subject.roles.should include(:bar)
      subject.roles.should have(2).elements
    end

    it "should accept multiple arguments as strings" do
      subject.send(:roles=, 'foo', 'bar')
      subject.roles.should include(:foo)
      subject.roles.should include(:bar)
      subject.roles.should have(2).elements
    end

    it "should silently ignore undefined roles" do
      subject.roles = :baz
      subject.roles.should be_empty
    end
  end

  describe "#has_role?" do
    subject { model_class.new }

    it "should return true when the given role was assigned" do
      subject.roles = :foo
      subject.should have_role(:foo)
    end

    it "should return false when the given role was not assigned" do
      subject.roles = :bar
      subject.should_not have_role(:foo)
    end

    it "should return false when no role was assigned" do
      subject.should_not have_role(:foo)
      subject.should_not have_role(:bar)
    end

    it "should return false when asked for an undefined role" do
      subject.should_not have_role(:baz)
    end
  end

end
