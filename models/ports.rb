class Port
    include DataMapper::Resource
    property :id, Serial
    property :port, Integer
    property :type, String
    property :name, String

   #has 1, :host, {:through => :port_mapping}
end
