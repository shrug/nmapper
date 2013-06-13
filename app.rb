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

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/nmap_devel.db")
DataMapper.finalize
DataMapper.auto_upgrade!


get '/' do
  @hosts=Host.all()

  erb :index
end

get "/host/:id" do
  @ports=[]
  @host=Host.get(params[:id])
  @ports=@host.ports
  @host.hostname = @host.ip4 if @host.hostname == nil
  @title = @host.hostname
  erb :host
end

get "/ports" do
  @title="Ports"
  @ports=Port.all
  erb :ports
end


get "/port/:id" do
  @port=Port.get(params[:id])
  @hosts=[]
  @hosts=@port.hosts
  @title = @port.port
  erb :port
end

