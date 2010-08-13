require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require "shared_factory_specs"
require 'rubyonacid/factories/random_walk'

include RubyOnAcid

describe "RandomWalkFactory" do
  
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new RandomWalkFactory();"
  end
  
  it_should_behave_like "a factory"
  
  it "increases or decreases prior key value by random amount within given interval" do
    values = []
    values << js("it.getUnit('x')")
    js("it.interval = 0.3")
    values << js("it.getUnit('x')")
    values[1].should be_close(values[0], 0.3)
    js("it.interval = 0.01")
    values << js("it.getUnit('x')")
    values[2].should be_close(values[1], 0.01)
  end
  
  it "adds random amount within given interval to source factories result if source factories are assigned"
  
end