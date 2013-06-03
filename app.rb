require 'sinatra'
require 'dm-core'
Dir.glob(File.expand_path("#{Dir.pwd}/models/*.rb", __FILE__)).each do |file|
      require file
end

configure do
      Sinatra::Application.reset!
        use Rack::Reloader
end

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/nmap.db")

get '/' do
  sortby = (params[:sortby] || 'tcpcount').to_sym
  sort_object = params[:sort_dir] == 'desc' ? sortby.desc : sortby.asc
  @hosts=Host.all(:order => [sort_object])
  @ports=Ports.all
  @os=Os.all

  erb :index
end
