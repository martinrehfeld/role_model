require 'spec_helper'

module CustomMatchers
  describe ArrayIncludingMatcher do

    it "should describe itself properly" do
      ArrayIncludingMatcher.new(:a, :b).description.should == "array_including(:a, :b)"
    end

    describe "passing" do
      it "should match the same array" do
        array_including(:a).should == [:a]
      end

      it "should match a array with extra stuff" do
        array_including(:a).should == [:a, :b]
      end

      it "should match a array regardless of element position" do
        array_including(:a, :b).should == [:b, :a]
      end

      describe "when matching against other matchers" do
        it "should match a symbol against anything()" do
          array_including(anything, :b).should == [:a, :b]
        end

        it "should match an int against anything()" do
          array_including(anything, :b).should == [1, :b]
        end

        it "should match a string against anything()" do
          array_including(anything, :b).should == ["1", :b]
        end

        it "should match an arbitrary object against anything()" do
          array_including(anything, :b).should == [Class.new.new, :b]
        end
      end
    end

    describe "failing" do
      it "should not match a non-array" do
        array_including(:a).should_not == :a
      end

      it "should not match a array with a missing element" do
        array_including(:a).should_not == [:b]
      end

      it "should not match an empty array with a given key" do
        array_including(:a).should_not == []
      end

      describe "when matching against other matchers" do
        it "should not match without additional elements" do
          array_including(anything, 1).should_not == [1]
        end
      end
    end
  end
end
