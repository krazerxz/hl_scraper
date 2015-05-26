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
      # need to refresh every 10 minutes
      sleep 1
      stock_table = find('#holdings-table').text
      write_to_file(stock_table)
    end


  end

  def write_to_file(data)
    @logger.info 'Scraper: Updating file'
    File.open('holdings', 'w') { |file| file.write(data) }
  end

end
