require 'data_mapper'
require 'nmap/xml'
require 'ipaddr'

Dir.glob(File.expand_path("#{Dir.pwd}/models/*.rb", __FILE__)).each do |file|
          require file
end

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/nmap_devel.db")
DataMapper.finalize
DataMapper.auto_upgrade!

puts "ARGV[0] = #{ARGV[0]}"
mapper=Nmap::XML.new(ARGV[0])

mapper.each_host do |host|
    next if host.status.state.to_s =~ /down/
    h=Host.first_or_create(:hostname => host.hostnames.first,
                :ip4 => host.ipv4,
                :ip4num => IPAddr.new(host.ipv4),
                :status => host.status.state.to_s,
                :tcpcount => host.tcp_ports.count,
                :udpcount => host.udp_ports.count
               )
    puts "Saving #{host.hostnames.first}: #{h.save}"
    host.each_port do |port|
      p = Port.first_or_create(:port => port.number,
                               :type => port.protocol,
                               :name => port.service
                              )
       puts "Saving port #{port.number}: #{p.save}"
       pm = PortMapping.new(:host_id => h.id,
                             :port_id => p.id,
                             :state => port.state.to_s
                            )
      puts "Saving port mapping for #{port.number}: #{pm.save}"
    end
end
