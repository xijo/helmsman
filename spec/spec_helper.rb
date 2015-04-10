require 'simplecov'

SimpleCov.profiles.define 'gem' do
  add_filter '/spec/'
  add_group 'Libraries', '/lib/'
end
SimpleCov.start 'gem'

require 'helmsman'

RSpec.configure do |config|
  config.color = true
end
