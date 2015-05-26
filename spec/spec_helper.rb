ENV['RACK_ENV'] = 'test'

require File.expand_path('../../hl_scraper.rb', __FILE__)

Dir[File.join(File.dirname(__FILE__), 'spec', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before :each do
    # DatabaseCleaner.strategy = :transaction
    # DatabaseCleaner.start
  end

  config.after do
    # DatabaseCleaner.clean
  end
end

def app
  HLScraper
end
