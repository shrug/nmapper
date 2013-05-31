require 'sinatra'
require 'dm-core'
Dir.glob(File.expand_path("models/*.rb", __FILE__)).each do |file|
      require file
end

configure do
      Sinatra::Application.reset!
        use Rack::Reloader
end

get '/' do
  erb :index
end

