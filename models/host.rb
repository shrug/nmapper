require 'ipaddr'

class Host
    include DataMapper::Resource

    property :id, Serial
    property :ip4, String
    property :ip4num, Integer
    property :hostname, String
    property :status, String
    property :tcpcount, Integer
    property :udpcount, Integer

    has n, :port_mappings
    has n, :ports, :through => :port_mappings


    def self.in_subnet(subnet)
        # Return all hosts in subnet
    end

end

