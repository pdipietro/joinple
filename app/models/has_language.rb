class HasLanguage
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :Tag
  to_class    :Language
  type 'has_language'

end