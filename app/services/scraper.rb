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

    @hl = HL.new(@logger)

    puts 'im here'

    define_websocket
  end

  def define_websocket
    EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|

      ws.onopen do
        puts "#{Time.now.strftime('%H:%M:%S')} : Client connected", '-'*80
        EventMachine.add_periodic_timer(1) do
          begin
            ws.send @hl.stock_data
          rescue
            puts "#{Time.now.strftime('%H:%M:%S')} : Failed to send data", '-'*80
          end
        end
        #ws.send @hl.stock_data
      end
      ws.onclose do
        puts "#{Time.now.strftime('%H:%M:%S')} : Client disconnected", '-'*80
      end

      ws.onmessage do |msg|
      end
    end
  end
end
