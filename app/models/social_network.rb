class SocialNetwork 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy
  include Name
  include Description

  property  :goals,  :type =>   String

  has_many  :in, :use_language, rel_class: Speaks
  #has_many  :in, :belongs_to, rel_class: BelongsTo

end
