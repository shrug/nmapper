class Port
    include DataMapper::Resource
    property :id, Serial
    property :port, Integer
    property :type, String
    property :name, String

    has n, :port_mappings
    has n, :hosts, :through => :port_mappings
end
