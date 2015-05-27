class HLScraper < Sinatra::Base

  get '/' do
    erb :'holdings_socket'
  end
end
