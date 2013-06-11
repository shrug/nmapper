class Port
    include DataMapper::Resource
    property :id, Serial
    property :port, Integer
    property :type, String
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

    belongs_to :host, :through => :port_mapping
end
