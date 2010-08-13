require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'rubyonacid/factories/repeat'
require "shared_factory_specs"

include RubyOnAcid

describe "RepeatFactory" do
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new RepeatFactory();"
  end
  
  describe "general behavior" do
  
    before :each do
      js("it.sourceFactories.push(new ConstantFactory({value: 0.2}));")
    end
  
    it_should_behave_like "a factory"
    
  end
  
  it "Requests a value from the source factory and repeats it a given number of times" do
    js("it.repeat_count = 2;")
    js("factory1 = new Factory();")
    js("it.sourceFactories.push(factory1);")
    js("factory1.getUnit = function () {return 0.0;}")
    js("it.getUnit('x')").should == 0.0
    js("it.getUnit('x')").should == 0.0
    js("factory1.getUnit = function () {return 1.0;}")
    js("it.getUnit('x')").should == 1.0
    js("it.getUnit('x')").should == 1.0
    js("factory1.getUnit = function () {return 0.5;}")
    js("it.getUnit('x')").should == 0.5
  end
  
  it "Tracks repeats on a per-key basis" do
    js("it.repeat_count = 2;")
    js("factory1 = new Factory();")
    js("it.sourceFactories.push(factory1);")
    js("factory1.getUnit = function () {return 0.0;}")
    js("it.getUnit('x')").should == 0.0
    js("factory1.getUnit = function () {return 1.0;}")
    js("it.getUnit('y')").should == 1.0
    js("it.getUnit('x')").should == 0.0
    js("it.getUnit('y')").should == 1.0
    js("factory1.getUnit = function () {return 0.5;}")
    js("it.getUnit('x')").should == 0.5
    js("factory1.getUnit = function () {return 0.75;}")
    js("it.getUnit('y')").should == 0.75
  end
  
end
