class Authorization
  include Neo4j::ActiveNode
	include CreatedAtUpdatedAt
	include Uuid

 # property :provider, type: String
 # property :uid, type: String
 # property :user_id, type: Integer
  property :token, type: String
  property :secret, type: String
  property :name, type: String
  property :url, type: String

  has_one: :out, :provider, model_class: :provider
  has_one: :out, :user

  def self.find_by_provider_and_uid(provider, user)
    Authorization.find(:provider => provider, :user => user)
  end

end
