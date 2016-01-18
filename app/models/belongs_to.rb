class BelongsTo
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :Group
  to_class    :SocialNetwork
  type 'belongs_to'

  property  :is_private,   :type =>   Boolean, default: false
  property  :is_open,      :type =>   Boolean, default: false

end