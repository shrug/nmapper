class Host
    include DataMapper::Resource
    property :id, Serial
    property :sid, Integer
    property :ip4, String
    property :ip4num, Integer
    property :hostname, String
    property :status, String
    property :tcpcount, Integer
    property :udpcount, Integer
    property :mac, String
    property :vendor, String
    property :ip6, String
    property :distance, Integer
    property :uptime, String
    property :upstr, String

    has n, :ports, :through => :port_mappings
end

