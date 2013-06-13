class PortMapping
  include DataMapper::Resource
  property :state, String

  belongs_to :host, :key => true
  belongs_to :port, :key => true
end
