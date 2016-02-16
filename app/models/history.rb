class History
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :any
  to_class    :any
  type 'previous'

end