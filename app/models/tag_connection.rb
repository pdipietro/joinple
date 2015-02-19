class TagConnection
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  Tag
  to_class    Tag
  type 'is_syn'

end