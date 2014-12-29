class SocialNetwork 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy
  include BelongsTo
  include Name
  include Description

  property  :goals,  :type =>   String

  has_many  :out, :speaks, type: :speaks
  has_many  :in, :belongings, type: :belongs

end
