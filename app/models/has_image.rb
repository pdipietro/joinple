class HasImage
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :any
  to_class    :Image
  type 'has_image'

  property  :type,             :type =>   String

end