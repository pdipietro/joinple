class HashTag
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :any
  to_class    :Tag
  type 'has_hashtag'

end