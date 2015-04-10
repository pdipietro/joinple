class PostBelongsTo
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  Post
  to_class    SocialNetwork
  type 'belongs_to'

end