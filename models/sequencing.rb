class Sequencing
    include DataMapper::Resource
    property :id, Serial
    property :sid, Integer
    property :hid, Integer
    property :tcpclass, String
    property :tcpindex, String
    property :tcpvalues, String
    property :ipclass, String
    property :ipvalues, String
    property :tcptclass, String
    property :tcptvalues, String
end
