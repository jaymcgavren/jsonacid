$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

require 'harmony'


def js(javascript)
  @page.execute_js(javascript)
end