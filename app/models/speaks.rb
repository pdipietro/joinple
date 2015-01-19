class Speaks
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :any
  to_class    Language
  type 'speaks'

end