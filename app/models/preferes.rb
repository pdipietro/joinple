class Preferes
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :Subject
  to_class    :any
  type 'preferes'

end