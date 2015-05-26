require 'bundler'
Bundler.require
require 'byebug' if ENV['RACK_ENV'] == 'development'

module HLScraper
  Dir[File.join(File.dirname(__FILE__), 'app', 'controllers', '*.rb')].each { |f| require f }
  Dir[File.join(File.dirname(__FILE__), 'app', 'services', '*.rb')].each    { |f| require f }
  Dir[File.join(File.dirname(__FILE__), 'app', 'models', '*.rb')].each    { |f| require f }
  Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each                { |f| require f }
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8

  include Capybara::DSL
  Capybara.default_driver = :poltergeist
end
