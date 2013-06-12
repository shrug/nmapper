class Host
    include DataMapper::Resource
    property :id, Serial
    property :ip4, String
    property :ip4num, Integer
    property :hostname, String
    property :status, String
    property :tcpcount, Integer
    property :udpcount, Integer

    #has n, :ports, :through => :port_mappings
end

