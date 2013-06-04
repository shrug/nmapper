require 'sinatra'
require 'data_mapper'
Dir.glob(File.expand_path("#{Dir.pwd}/models/*.rb", __FILE__)).each do |file|
      require file
end

configure :development do
  enable :logging, :dump_errors, :raise_errors
  
      Sinatra::Application.reset!
        use Rack::Reloader
end

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/nmap.db")
DataMapper.finalize


get '/' do
  sortby = (params[:sortby] || 'tcpcount').to_sym
  sort_object = params[:sort_dir] == 'asc' ? sortby.asc : sortby.desc
  @hosts=Host.all(:status=>"up", :order => [sort_object])

  erb :index
end

get "/host/:id" do
  @host=Host.get(params[:id])
  @ports=Port.all(:hid=>params[:id])
  @title = @host.hostname
  erb :host
end
