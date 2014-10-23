class Share
  include Neo4j::ActiveNode
  property :from_user_id, type: Integer
  property :to_user_id, type: Integer
  property :to_email, type: String
  property :created_at, type: DateTime
  property :url, type: String

	has_many :out, :belongs_to,	origin: :User,  model_class: User
	has_many :in,	 :owns,	origin: :User,  model_class: User

end
