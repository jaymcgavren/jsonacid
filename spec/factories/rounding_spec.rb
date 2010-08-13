require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'rubyonacid/factories/rounding'
require "shared_factory_specs"

include RubyOnAcid

describe "RoundingFactory" do
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new RoundingFactory();"
  end
  

  describe "general behavior" do
  
    before :each do
      js("it.sourceFactories.push(new ConstantFactory({value: 0.2}));")
    end
  
    it_should_behave_like "a factory"
    
  end
  
  it "Requests a value from the source factory and rounds it to a multiple of the requested number" do
    js("factory1 = new Factory();")
    js("it.sourceFactories.push(factory1);")
    js("it.nearest = 0.3;")
    js("factory1.getUnit = function () {return 0.7;}")
    js("it.getUnit('x')").should be_close(0.6, MARGIN)
    js("factory1.getUnit = function () {return 0.8;}")
    js("it.getUnit('x')").should be_close(0.9, MARGIN)
    js("factory1.getUnit = function () {return 0.9;}")
    js("it.getUnit('x')").should be_close(0.9, MARGIN)
    js("factory1.getUnit = function () {return 1.0;}")
    js("it.getUnit('x')").should be_close(0.9, MARGIN)
  end
  
  it "can round to multiples of 0.2" do
    js("it.nearest = 0.2;")
    js("factory1 = new Factory();")
    js("it.sourceFactories.push(factory1);")
    js("factory1.getUnit = function () {return 0.0;}")
    js("it.getUnit('x')").should be_close(0.0, MARGIN)
    js("factory1.getUnit = function () {return 0.11;}")
    js("it.getUnit('x')").should be_close(0.2, MARGIN)
    js("factory1.getUnit = function () {return 0.2;}")
    js("it.getUnit('x')").should be_close(0.2, MARGIN)
    js("factory1.getUnit = function () {return 0.31;}")
    js("it.getUnit('x')").should be_close(0.4, MARGIN)
    js("factory1.getUnit = function () {return 0.4;}")
    js("it.getUnit('x')").should be_close(0.4, MARGIN)
  end
  
  it "can round to multiples of 1.0" do
    js("it.nearest = 1.0;")
    js("factory1 = new Factory();")
    js("it.sourceFactories.push(factory1);")
    js("factory1.getUnit = function () {return 0.0;}")
    js("it.getUnit('x')").should be_close(0.0, MARGIN)
    js("factory1.getUnit = function () {return 0.4;}")
    js("it.getUnit('x')").should be_close(0.0, MARGIN)
    js("factory1.getUnit = function () {return 0.51;}")
    js("it.getUnit('x')").should be_close(1.0, MARGIN)
    js("factory1.getUnit = function () {return 0.9;}")
    js("it.getUnit('x')").should be_close(1.0, MARGIN)
    js("factory1.getUnit = function () {return 1.0;}")
    js("it.getUnit('x')").should be_close(1.0, MARGIN)
  end
  
end
