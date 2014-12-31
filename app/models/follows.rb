class Follows
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  User
  to_class    :any
  type 'follows'

end