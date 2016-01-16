class Likes
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :Subject
  to_class    :any
  type 'likes'

end