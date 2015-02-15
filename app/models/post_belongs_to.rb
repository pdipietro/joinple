class PostBelongsTo
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  Post
  to_class    :any
  type 'belongs_to'

end