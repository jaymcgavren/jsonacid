require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require "shared_factory_specs"
require 'rubyonacid/factories/skip'

include RubyOnAcid

describe "SkipFactory" do
  
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new SkipFactory();"
  end
  
  it_should_behave_like "a factory"
  
  it "generates only 0 or 1" do
    js("it.odds = 0.1;")
    300.times do
      [0, 1].should include(js("it.getUnit('x');"))
    end
  end
  
  
end