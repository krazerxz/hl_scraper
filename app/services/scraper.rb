include Capybara::DSL
Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

class Scraper
  def initialize
  end

  def run
    @logger = Logger.new(File.expand_path('../../../log/hl.log', __FILE__)).tap do |log|
      log.progname = 'scraper'
      log.level = Kernel.const_get('Logger::INFO')
    end

    HL.new(@logger)

    while true do
      sleep 2
      write_to_file
    end

    # document = Nokogiri::HTML(page.body)
    # page.body


  end

  def write_to_file
    data = find('#holdings-table').text
    require 'byebug'
    debugger
    @logger.info 'Scraper: Updating file'
    File.open('holdings', 'w') { |file| file.write(data) }
  end

end
