class Provider
  include Neo4j::ActiveNode

	include CreatedAtUpdatedAt
	include Uuid
	include Name
	include Description

  has_many :in, :user_identities, origin: :provider

  def find_by_name (name)
    Neo4j::Session.query.match("(provider:Provider {name : #{block}}) return provider;")
  end

end