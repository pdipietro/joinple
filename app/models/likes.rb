class Likes
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  User
  to_class    :any
  type 'likes'

end