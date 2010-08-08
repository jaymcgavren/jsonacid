require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require "shared_factory_specs"
require 'rubyonacid/factories/flash'

include RubyOnAcid

describe FlashFactory do
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new FlashFactory();"
  end
  
  it_should_behave_like "a factory"
  
  it "returns 1.0 three times, then 0.0 three times, then loops" do
    js("it.getUnit('x');").should == 1.0
    js("it.getUnit('x');").should == 1.0
    js("it.getUnit('x');").should == 1.0
    js("it.getUnit('x');").should == 0.0
    js("it.getUnit('x');").should == 0.0
    js("it.getUnit('x');").should == 0.0
    js("it.getUnit('x');").should == 1.0
    js("it.getUnit('x');").should == 1.0
    js("it.getUnit('x');").should == 1.0
    js("it.getUnit('x');").should == 0.0
    js("it.getUnit('x');").should == 0.0
    js("it.getUnit('x');").should == 0.0
  end
  
  it "can take a different interval" do
    js("it.interval = 2")
    js("it.getUnit('x');").should == 1.0
    js("it.getUnit('x');").should == 1.0
    js("it.getUnit('x');").should == 0.0
    js("it.getUnit('x');").should == 0.0
    js("it.getUnit('x');").should == 1.0
  end
  
  it "handles multiple keys" do
    js("it.interval = 2")
    js("it.getUnit('x');").should == 1.0
    js("it.getUnit('y');").should == 1.0
    js("it.getUnit('x');").should == 1.0
    js("it.getUnit('y');").should == 1.0
    js("it.getUnit('x');").should == 0.0
    js("it.getUnit('y');").should == 0.0
  end
  
end
