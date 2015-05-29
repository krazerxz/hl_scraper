include Capybara::DSL
Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
#Capybara.default_max_wait_time = 1

class Scraper
  def initialize
  end

  def run
    @logger = Logger.new($stdout).tap do |log|
    #@logger = Logger.new(File.expand_path('../../../log/hl.log', __FILE__)).tap do |log|
      log.progname = 'scraper'
      log.level = Kernel.const_get('Logger::INFO')
    end

    @hl = HL.new(@logger)

    define_websocket
  end

  def define_websocket
    @logger.info 'SC: Listening for connections'

    EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
      ws.onopen do
        @logger.info 'SC: Client connected'
        EventMachine.add_periodic_timer(1) do
          begin
            ws.send @hl.stock_data
          rescue
            @logger.warn 'SC: Failed to send data - Time out?'
            #@logger.info 'SC: Refreshing holdings page'
            #@hl.refresh_holdings_page
          end
        end
      end
      ws.onclose do
        @logger.info 'SC: Client disconnected'
      end

      ws.onmessage do |msg|
      end
    end
  end
end
