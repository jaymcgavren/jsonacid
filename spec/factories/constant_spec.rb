require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require "shared_factory_specs"

describe "ConstantFactory" do
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new ConstantFactory();"
  end
  
  
  it_should_behave_like "a factory"
  

  it "always returns the same value" do
    js("it.value = 0.1")
    js("it.getUnit('x')").should == 0.1
    js("it.getUnit('x')").should == 0.1
  end
  
end
