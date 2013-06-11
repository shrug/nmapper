class Nmap
    include DataMapper::Resource
    property :id, Serial
    property :version, String
    property :xmlversion, String
    property :args, String
    property :types, String
    property :starttime, DateTime
    property :startstr, String
    property :endtime, DateTime
    property :endstr, String
    property :numservices, Integer
end

