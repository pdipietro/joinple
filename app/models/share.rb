class Share
  include Neo4j::ActiveNode
  property :from_user_id, type: Integer
  property :to_user_id, type: Integer
  property :to_email, type: String
  property :created_at, type: DateTime
  property :url, type: String

  has_one :in, :user, from: :shares
  has_many :out, :users, type: :is_shared_with

end
