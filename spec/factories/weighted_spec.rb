require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require "shared_factory_specs"

include RubyOnAcid

describe "WeightedFactory" do

  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new WeightedFactory();"
  end
  

  describe "general behavior" do
  
    before :each do
      js("it.sourceFactories.push(new ConstantFactory({value: 0.2}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.3}));")
    end
  
    it_should_behave_like "a factory"
    
  end
  
  describe "#get_unit" do
      
    it "gives factories with higher weights more influence" do
      js("factory1 = new Factory();")
      js("factory1.getUnit = function () {return 0.25;}")
      js("it.sourceFactories.push(factory1);")
      js("factory2 = new Factory();")
      js("factory2.getUnit = function () {return 0.75;}")
      js("it.sourceFactories.push(factory2);")
      js("it.getUnit('x');").should be_close(0.5, MARGIN)
      js("it.setWeight(factory1, 1.0);")
      js("it.setWeight(factory2, 2.0);")
      js("it.getUnit('x')").should > 0.5
    end
  
    it "multiplies factory values by weights when averaging" do
      js("factory1 = new Factory();")
      js("factory1.getUnit = function () {return 0.2;}")
      js("it.sourceFactories.push(factory1);")
      js("factory2 = new Factory();")
      js("factory2.getUnit = function () {return 0.4;}")
      js("it.sourceFactories.push(factory2);")
      js("it.getUnit('x')").should be_close(0.3, MARGIN)
      js("it.setWeight(factory1, 2.0);") #0.2 * 2.0 = 0.4
      js("it.setWeight(factory2, 4.0);") #0.4 * 4.0 = 1.6
      #0.4 + 1.6 = 2.0
      #2.0 / 6.0 (total weight) = 0.333
      js("it.getUnit('x')").should be_close(0.333, MARGIN)
    end
    
    it "can handle 3 or more factories" do
      js("factory1 = new Factory();")
      js("factory1.getUnit = function () {return 0.2;}")
      js("it.sourceFactories.push(factory1);")
      js("factory2 = new Factory();")
      js("factory2.getUnit = function () {return 0.4;}")
      js("it.sourceFactories.push(factory2);")
      js("factory3 = new Factory();")
      js("factory3.getUnit = function () {return 0.8;}")
      js("it.sourceFactories.push(factory3);")
      js("it.getUnit('x')").should be_close(0.4666, MARGIN)
      js("it.setWeight(factory1, 10.0);") #0.2 * 10.0 = 2.0
      js("it.setWeight(factory2, 3.0);") #0.4 * 3.0 = 1.2
      js("it.setWeight(factory3, 2.0);") #0.8 * 2.0 = 1.6
      #2.0 + 1.2 + 1.6 = 4.8
      #puts 4.8 / 15.0 (total weight) = 0.32
      js("it.getUnit('x')").should be_close(0.32, MARGIN)
    end
    
  end
  
  
end
