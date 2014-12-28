class SocialNetwork 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy
  include Name
  include Description

  property  :goals,  :type =>   String

  has_many  :out, :speaks, type: :speaks

end
