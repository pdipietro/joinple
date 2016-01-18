class HasHashTag
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :any
  to_class    :HashTag
  type 'has_hash_tag'

end