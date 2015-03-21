class HasImage
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  User
  to_class    Image
  type 'has_image'

end