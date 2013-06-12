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
    #next if Host.all(:hostname => host.hostnames.first)
    h=Host.first_or_create(:hostname => host.hostnames.first,
                :ip4 => host.ipv4,
                :ip4num => IPAddr.new(host.ipv4),
                :status => host.status.state.to_s,
                :tcpcount => host.tcp_ports.count,
                :udpcount => host.udp_ports.count
               )
    puts h.save
    host.each_port do |port|
      p = Port.first_or_create(:port => port.number,
                               :type => port.protocol,
                               :name => port.service
                              )
       p.save
       pm = Port_mapping.new(:host_id => h.id,
                             :port_id => p.id,
                             :state => port.state.to_s
                            )
      pm.save
    end
end
