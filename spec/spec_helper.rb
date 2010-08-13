$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'spec'
require 'spec/autorun'


#Allowed margin of error for be_close.
MARGIN = 0.001


Spec::Runner.configure do |config|
  
end

require 'harmony'


def js(javascript)
  @page.execute_js(javascript)
end