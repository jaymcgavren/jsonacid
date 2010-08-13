require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require "shared_factory_specs"

include RubyOnAcid

describe "CombinationFactory" do

  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new CombinationFactory();"
  end
  

  describe "general behavior" do
  
    before :each do
      js("it.sourceFactories.push(new ConstantFactory({value: 0.2}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.3}));")
    end
  
    it_should_behave_like "a factory"
    
  end
  
  describe "#get_unit" do
      
    it "retrieves values from source factories and adds them together" do
      js("it.sourceFactories.push(new ConstantFactory({value: 0.2}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.3}));")
      js("it.getUnit('x')").should be_close(0.5, MARGIN)
      js("it.sourceFactories.push(new ConstantFactory({value: 0.1}));")
      js("it.getUnit('x')").should be_close(0.6, MARGIN)
    end
  
    it "can constrain sum to 0.0 through 1.0" do
      js("it.constrainMode = CombinationFactory.CONSTRAIN_MODE.constrain")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.2}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.3}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.7}));")
      js("it.getUnit('x')").should be_close(1.0, MARGIN)
    end
    
    it "uses wrap mode by default" do
      js("it.sourceFactories.push(new ConstantFactory({value: 0.4}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.7}));")
      js("it.getUnit('x')").should be_close(0.1, MARGIN)
    end
    
    it "can wrap > 1.0 value around" do
      js("it.constrainMode = CombinationFactory.CONSTRAIN_MODE.wrap")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.2}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.3}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.7}));")
      js("it.getUnit('x')").should be_close(0.2, MARGIN)
    end
    
  end
  
  describe "subtraction" do
    
    it "can subtract values from source factories" do
      js("it.operation = CombinationFactory.OPERATION.subtract")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.7}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.3}));")
      js("it.getUnit('x')").should be_close(0.4, MARGIN)
      js("it.sourceFactories.push(new ConstantFactory({value: 0.1}));")
      js("it.getUnit('x')").should be_close(0.3, MARGIN)
    end
    
    it "can wrap < 0.0 value around" do
      js("it.operation = CombinationFactory.OPERATION.subtract")
      js("it.constrainMode = CombinationFactory.CONSTRAIN_MODE.wrap")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.5}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.7}));")
      js("it.getUnit('x')").should be_close(0.8, MARGIN)
    end
    
  end
  
  describe "multiplication" do
    it "can get product of values from source factories" do
      js("it.operation = CombinationFactory.OPERATION.multiply")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.7}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.5}));")
      js("it.getUnit('x')").should be_close(0.35, MARGIN)
      js("it.sourceFactories.push(new ConstantFactory({value: 0.1}));")
      js("it.getUnit('x')").should be_close(0.035, MARGIN)
    end
  end
    
  describe "division" do
    it "can divide values from source factories" do
      js("it.operation = CombinationFactory.OPERATION.divide")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.1}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.2}));")
      js("it.getUnit('x')").should be_close(0.5, MARGIN) #0.1 / 0.2 = 0.5
      js("it.sourceFactories.push(new ConstantFactory({value: 0.9}));")
      js("it.getUnit('x')").should be_close(0.555, MARGIN) #0.5 / 0.9 = 0.5555...
    end
  end
  
end
