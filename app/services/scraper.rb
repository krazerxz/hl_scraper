include Capybara::DSL
Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
#Capybara.default_max_wait_time = 1

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
      sleep 1
      ws.onmessage { |msg| ws.send hl.stock_data }
    end
    #while true do
    #end
  end
end
