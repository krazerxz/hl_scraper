class HLScraper < Sinatra::Base

  get '/' do
    erb :'dashboard'
  end
end
