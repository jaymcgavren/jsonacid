require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'rubyonacid/factories/proximity'
require "shared_factory_specs"

include RubyOnAcid

describe "ProximityFactory" do
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new ProximityFactory();"
  end

  describe "general behavior" do
  
    before :each do
      js("it.sourceFactories.push(new ConstantFactory({value: 0.2}));")
    end
  
    it_should_behave_like "a factory"
    
  end
  
  describe "#get_unit" do
    it "requests value from the source factory and scales it based on its proximity to the target value" do
      js("it.target = 0.5;")
      js("factory1 = new Factory();")
      js("it.sourceFactories.push(factory1);")
      js("factory1.getUnit = function () {return 0.5;}")
      near_value = js("it.getUnit('x');")
      js("factory1.getUnit = function () {return 0.7;}")
      far_value = js("it.getUnit('x');")
      near_value.should > far_value
    end
    
    it "should return 1.0 if source value matches target exactly" do
      js("it.target = 0.5;")
      js("factory1 = new Factory();")
      js("it.sourceFactories.push(factory1);")
      js("factory1.getUnit = function () {return 0.5;}")
      js("it.getUnit('x')").should be_close(1.0, MARGIN)
    end
    
    it "should approach zero as distance approaches 1.0" do
      js("it.target = 1.0;")
      js("factory1 = new Factory();")
      js("it.sourceFactories.push(factory1);")
      js("factory1.getUnit = function () {return 0.0;}")
      js("it.getUnit('x')").should be_close(0.0, MARGIN)
    end
  end
  
end
