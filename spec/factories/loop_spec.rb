require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require "shared_factory_specs"
require 'rubyonacid/factories/loop'

include RubyOnAcid

describe "LoopFactory" do
  
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new LoopFactory();"
  end
  
  it_should_behave_like "a factory"
  
  it "Loops to 0 if increment is positive" do
    js("it.interval = 0.3")
    js("it.getUnit('x')").should be_close(0.3, MARGIN)
    js("it.getUnit('x')").should be_close(0.6, MARGIN)
    js("it.getUnit('x')").should be_close(0.9, MARGIN)
    js("it.getUnit('x')").should be_close(0.2, MARGIN)
    js("it.getUnit('x')").should be_close(0.5, MARGIN)
  end
  
  it "Loops to 1 if increment is negative" do
    js("it.interval = -0.3")
    js("it.getUnit('x')").should be_close(0.7, MARGIN)
    js("it.getUnit('x')").should be_close(0.4, MARGIN)
    js("it.getUnit('x')").should be_close(0.1, MARGIN)
    js("it.getUnit('x')").should be_close(0.8, MARGIN)
    js("it.getUnit('x')").should be_close(0.5, MARGIN)
  end
  
  it "handles multiple keys" do
    js("it.interval = 0.3")
    js("it.getUnit('x')").should be_close(0.3, MARGIN)
    js("it.getUnit('y')").should be_close(0.3, MARGIN)
    js("it.getUnit('x')").should be_close(0.6, MARGIN)
    js("it.getUnit('y')").should be_close(0.6, MARGIN)
  end
  
end