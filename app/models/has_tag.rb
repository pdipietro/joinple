class HasTag
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :any
  to_class    Tag
  type 'has_tag'

end