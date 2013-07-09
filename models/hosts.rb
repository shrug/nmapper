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
        
        # TODO: check this for validity before we do anything with it
        net=IPAddr.new(subnet)
        
        hosts=Host.all
        puts hosts.count
        ihosts=[]
        hosts.each do |host|
          puts host.hostname
          ihosts.push[host] if net.include? IPAddr.new(host.ip4)
        end
        ihosts
        
        
        
        #return IPAddr.new(subnet).include? IPAddr.new(@ip4)

    end

end

