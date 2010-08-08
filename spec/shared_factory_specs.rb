require 'rubyonacid/factory'

include RubyOnAcid

shared_examples_for "a factory" do
  
  describe "getUnit()" do
    it "returns a value between 0.0 and 1.0 (inclusive) for a key" do
      value = js("it.getUnit('any_key');")
      value.should_not be_nil
      value.should >= 0.0
      value.should <= 1.0
    end
  end
  
  describe "#get" do
    it "allows setting a maximum" do
      js("it.getUnit('x');").should == 1.0
      js("it.get('a', 2.0);").should <= 2.0
      js("it.get('b', 10.0);").should <= 10.0
      js("it.get('c', 100.0);").should <= 100.0
      js("it.get('d', 1000.0);").should <= 1000.0
    end
    it "allows setting a minimum" do
      js("it.get('a', 2.0, 3.0)").should >= 2.0
      js("it.get('b', -1.0, 0.0)").should >= -1.0
      js("it.get('c', -100.0, 100.0)").should >= -100.0
      js("it.get('d', 1000.0, 1000.1)").should >= 1000.0
    end
    it "uses a default minimum of 0.0" do
      js("it.get('a')").should >= 0.0
      js("it.get('a', 10.0)").should >= 0.0
    end
    it "uses a default maximum of 1.0" do
      js("it.get('a')").should <= 1.0
    end
  end
    
end
