require File.expand_path '../../app.rb', __FILE__

ENV['RACK_ENV'] = "test"

require 'rspec'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/webkit'
require 'rack/test'
require 'capybara/poltergeist'

#require 'webmock/rspec'

set :environment, :test
set :run, false
set :logging, false

Capybara.javascript_driver = :webkit
Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, headers: { HTTP_USER_AGENT: 'Capybara' })
end
Capybara.app = MASPayment

module RSpecMixin
  def app
    MASPayment
  end
end

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true
  config.formatter = :documentation
  config.include Capybara::DSL
  config.include Rack::Test::Methods
  config.include RSpecMixin
end

#Capybara::Webkit.configure do |config|
#  config.debug = true
#  config.block_unknown_urls
#  config.allow_unknown_urls
#  config.timeout = 5
#  config.ignore_ssl_errors
#end
