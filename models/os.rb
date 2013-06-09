class Os
    include DataMapper::Resource
    property :id, Serial
    property :sid, Integer
    property :hid, Integer
    property :name, String
    property :family, String
    property :generation, String
    property :type, String
    property :vendor, String
    property :accuracy, Integer
end

