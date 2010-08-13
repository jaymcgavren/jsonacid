require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'rubyonacid/factories/meta'
require "shared_factory_specs"

include RubyOnAcid

describe "MetaFactory" do
  
  before :each do
    @page = Harmony::Page.new
    @page.load('lib/jsonacid.js')
    @page.execute_js "var it = new MetaFactory();"
  end


  describe "general behavior" do
  
    before :each do
      js("it.sourceFactories.push(new ConstantFactory({value: 0.2}));")
      js("it.sourceFactories.push(new ConstantFactory({value: 0.1}));")
    end
  
    it_should_behave_like "a factory"
    
  end
  
  
  it "takes a list of factories, then randomly and permanently assigns a factory to each requested key" do
    js("it.sourceFactories.push(new ConstantFactory({value: 0.0}));")
    js("it.sourceFactories.push(new ConstantFactory({value: 1.0}));")
    ('a'..'z').each do |key|
      js("it.getUnit(key.to_sym)").should == js("it.getUnit(key.to_sym)")
    end
  end
  
end
