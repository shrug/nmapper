class Port
    include DataMapper::Resource

    property :hid, Integer, :key => true
    property :port, Integer, :key => true
    property :type, String
    property :state, String
    property :name, String
    property :tunnel, String
    property :product, String
    property :version, String
    property :extra, String
    property :confidence, Integer
    property :method, String
    property :proto, String
    property :owner, String
    property :rpcnum, String
    property :fingerprint, String

    belongs_to :host
end
