ENV['RACK_ENV'] ||= 'test'

Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |r| load r }

require_relative './hl_scraper.rb'
