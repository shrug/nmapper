class Nmap
    include DataMapper::Resource

    property :sid, Serial
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

