class Sequencing
    include DataMapper::Resource

    property :hid, Integer, :key => true
    property :tcpclass, String
    property :tcpindex, String
    property :tcpvalues, String
    property :ipclass, String
    property :ipvalues, String
    property :tcptclass, String
    property :tcptvalues, String
end
