class Authorization
  include Neo4j::ActiveNode
#	include Uuid

  property :provider, type: String
  property :uid, type: String
  property :user_id, type: Integer
  property :token, type: String
  property :secret, type: String
  property :name, type: String
  property :url, type: String

  has_one :in, :user, from: :autorizations
end
