require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require "shared_factory_specs"
require 'rubyonacid/factories/sine'

include RubyOnAcid

describe "SineFactory" do
  
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new SineFactory();"
  end
  
  it_should_behave_like "a factory"
  
  it "loops between 0 and 1" do
    js("it.interval = 1.0;")
    js("it.getUnit('x')").should be_close(0.920, MARGIN)
    js("it.getUnit('x')").should be_close(0.954, MARGIN)
    js("it.getUnit('x')").should be_close(0.570, MARGIN)
    js("it.getUnit('x')").should be_close(0.122, MARGIN)
    js("it.getUnit('x')").should be_close(0.020, MARGIN)
    js("it.getUnit('x')").should be_close(0.360, MARGIN)
  end
  
  it "can take a different interval" do
    js("it.interval = 0.5;")
    js("it.getUnit('x')").should be_close(0.740, MARGIN)
    js("it.getUnit('x')").should be_close(0.920, MARGIN)
  end
  
  it "handles multiple keys" do
    js("it.interval = 1.0;")
    js("it.getUnit('x')").should be_close(0.920, MARGIN)
    js("it.getUnit('y')").should be_close(0.920, MARGIN)
    js("it.getUnit('x')").should be_close(0.954, MARGIN)
    js("it.getUnit('y')").should be_close(0.954, MARGIN)
  end
  
end