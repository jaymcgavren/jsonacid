require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require "shared_factory_specs"

describe "InputFactory" do

  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new InputFactory();"
  end

  describe "general behavior" do
  
    before :each do
      js("it.sourceFactories.push(new ConstantFactory({value: 0.2}));")
    end
  
    it_should_behave_like "a factory"
    
  end
  
  describe "#get_unit" do
    
    it "retrieves values assigned to a key" do
      js("it.put('x', 0.1)")
      js("it.getUnit('x')").should == 0.1
    end
    
    it "stores only latest input value" do
      js("it.put('x', 0.1)")
      js("it.put('x', 0.2)")
      js("it.getUnit('x')").should == 0.2
    end
    
    it "maps to a different key if the requested one isn't present" do
      js("it.put('x', 0.1)")
      js("it.getUnit('y')").should == 0.1
    end
    
    it "returns 0 if a key has no values" do
      js("it.getUnit('z')").should == 0.0
    end
  
    it "returns 0 only after mapping a different key" do
      js("it.put('x', 0.2)")
      js("it.getUnit('y')").should == 0.2
      js("it.getUnit('z')").should == 0.0
    end
  
  end
  
  describe "scaling" do
    
    it "scales highest seen values for a key to 0 to 1 range" do
      js("it.put('x', 0.0)")
      js("it.getUnit('x')").should be_close(0.0, MARGIN)
      js("it.put('x', 1.0)")
      js("it.getUnit('x')").should be_close(1.0, MARGIN)
      js("it.put('x', 2.0)")
      js("it.getUnit('x')").should be_close(1.0, MARGIN)
      js("it.put('x', 1.0)")
      js("it.getUnit('x')").should be_close(0.5, MARGIN)
      js("it.put('x', 0.0)")
      js("it.getUnit('x')").should be_close(0.0, MARGIN)
      js("it.put('x', 4.0)")
      js("it.getUnit('x')").should be_close(1.0, MARGIN)
      js("it.put('x', 3.0)")
      js("it.getUnit('x')").should be_close(0.75, MARGIN)
      js("it.put('x', 0.0)")
      js("it.getUnit('x')").should be_close(0.0, MARGIN)
    end
    
    it "scales lowest seen values for a key to 0 to 1 range" do
      js("it.put('x', 0.0)")
      js("it.getUnit('x')").should be_close(0.0, MARGIN)
      js("it.put('x', 1.0)")
      js("it.getUnit('x')").should be_close(1.0, MARGIN)
      js("it.put('x', -2.0)")
      js("it.getUnit('x')").should be_close(0.0, MARGIN)
      js("it.put('x', 1.0)")
      js("it.getUnit('x')").should be_close(1.0, MARGIN)
      js("it.put('x', 0.0)")
      js("it.getUnit('x')").should be_close(0.666, MARGIN)
      js("it.put('x', -2.0)")
      js("it.getUnit('x')").should be_close(0.0, MARGIN)
      js("it.put('x', 2.0)")
      js("it.getUnit('x')").should be_close(1.0, MARGIN)
      js("it.put('x', 1.0)")
      js("it.getUnit('x')").should be_close(0.75, MARGIN)
    end
    
  end
  
end
