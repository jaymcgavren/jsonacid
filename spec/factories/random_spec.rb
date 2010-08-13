require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require "shared_factory_specs"

include RubyOnAcid

describe "RandomFactory" do
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new RandomFactory();"
  end
  
  it_should_behave_like "a factory"
  
  it "generates random numbers between 0 and 1" do
    js("it.getUnit('x')").should_not == js("it.getUnit('x')")
    js("it.getUnit('x')").should_not == js("it.getUnit('x')")
  end
  
end