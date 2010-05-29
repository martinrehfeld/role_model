$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'role_model'
require 'spec'
require 'spec/autorun'
require File.dirname(__FILE__) + "/custom_matchers"

Spec::Runner.configure do |config|
  config.include(CustomMatchers)
end
