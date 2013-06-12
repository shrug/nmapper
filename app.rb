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
  @ports=Port.all(:hid=>params[:id]) #, :state=>"open")
  @host.hostname = @host.ip4 if @host.hostname =~ /\A\W*\Z/
  @title = @host.hostname
  erb :host
end

get "/ports" do
  @title="Ports"
  @ports=[]
  @ports=Port.all(:order=>:port)
  @u_ports=@ports.uniq {|p| [p.port, p.type]} 
  erb :ports
end


get "/port/:id" do
  @ports=[]
  @ports=Port.all(:port=>params[:id]) #, :state=>"open")
  @hosts=[]
  @ports.each do |port|
    @hosts.push(Host.get(port.hid))
  end
  @title = @ports.first.port
  erb :port
end

