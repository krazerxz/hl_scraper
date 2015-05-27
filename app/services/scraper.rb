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

    hl = HL.new(@logger)

    puts 'im here'

    EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
      ws.onopen    { ws.send "Hello Client!"}
      require 'byebug'
      debugger
      ws.onmessage { |msg| ws.send hl.stock_data }
    end

    #while true do
    #sleep 1
    #write_to_file(hl.stock_data)
    #end
  end

  def write_to_file(data)
    @logger.info 'Scraper: Updating file'
    File.open('log/holdings', 'w') { |file| file.write(data) }
  end
end
