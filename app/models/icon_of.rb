class IconOf
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :any
  to_class    User
  type 'is_icon_of'

end