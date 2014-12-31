class Speaks
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :any
  to_class    Language
  type 'is_spoken_by'

end