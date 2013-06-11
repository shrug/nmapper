Class Port_mapping
  include DataMapper::Resource
  property :host_id, Integer, :key => true
  property :port_id, Integer, :key => true
  property :state, String

  belongs_to :host, :key => true
  belongs_to :port, :key => true
end
