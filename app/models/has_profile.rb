class HasProfile
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  User
  to_class    UserProfile
  type 'has_profile'

end