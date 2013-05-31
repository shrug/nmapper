class Os
    include DataMapper::Resource

    property :hid, Integer
    property :name, String, :key => true
    property :family, String
    property :generation, String
    property :type, String
    property :vendor, String
    property :accuracy, Integer
end

