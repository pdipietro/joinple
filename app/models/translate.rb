class Translate
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  Tag
  to_class    Tag
  type 'translate'

end