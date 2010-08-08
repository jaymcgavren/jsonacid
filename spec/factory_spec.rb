require File.join(File.dirname(__FILE__), 'spec_helper')
require "shared_factory_specs"

describe "Factory" do
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new Factory();"
  end
  
  describe "#choose" do
    
    it "chooses an item from a list" do
      js("it.getUnit = function () {return 0.0;}")
      js("it.choose('color', 'red', 'green', 'blue')").should == "red"
      js("it.getUnit = function () {return 1.0;}")
      js("it.choose('color', 'red', 'green', 'blue')").should == "blue"
      js("it.getUnit = function () {return 0.5;}")
      js("it.choose('color', 'red', 'green', 'blue')").should == "green"
    end
    
    it "matches a range of values for each list item" do
      js("it.getUnit = function () {return 0.0;}")
      js("it.choose('foo', 'a', 'b', 'c', 'd')").should == "a"
      js("it.getUnit = function () {return 0.24;}")
      js("it.choose('foo', 'a', 'b', 'c', 'd')").should == "a"
      js("it.getUnit = function () {return 0.25;}")
      js("it.choose('foo', 'a', 'b', 'c', 'd')").should == "b"
      js("it.getUnit = function () {return 0.49;}")
      js("it.choose('foo', 'a', 'b', 'c', 'd')").should == "b"
      js("it.getUnit = function () {return 0.5;}")
      js("it.choose('foo', 'a', 'b', 'c', 'd')").should == "c"
      js("it.getUnit = function () {return 0.74;}")
      js("it.choose('foo', 'a', 'b', 'c', 'd')").should == "c"
      js("it.getUnit = function () {return 0.75;}")
      js("it.choose('foo', 'a', 'b', 'c', 'd')").should == "d"
      js("it.getUnit = function () {return 1.0;}")
      js("it.choose('foo', 'a', 'b', 'c', 'd')").should == "d"
    end
    
    it "accepts multiple arguments" do
      js("it.getUnit = function () {return 1.0;}")
      js("it.choose('color', 'red', 'green', 'blue')").should == "blue"
    end
    
    it "accepts arrays" do
      js("it.getUnit = function () {return 1.0;}")
      js("it.choose('color', ['red', 'green', 'blue'])").should == "blue"
    end
    
  end
  
  
  describe "sourceFactories()" do
    
    it "calls getUnit() on each and averages results" do
      js("factory1 = new Factory();")
      js("factory1.getUnit = function () {return 0.1;}")
      js("it.sourceFactories.push(factory1);")
      js("factory2 = new Factory();")
      js("factory2.getUnit = function () {return 0.2;}")
      js("it.sourceFactories.push(factory2);")
      js("factory3 = new Factory();")
      js("factory3.getUnit = function () {return 0.3;}")
      js("it.sourceFactories.push(factory3);")
      js("it.getUnit();").should be_close(0.2, 0.001)
    end
    
  end
  
  
end