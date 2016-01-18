class TakesPlaceIn
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :Group
  to_class    :SocialNetwork
  type 'takes_place_in'

  property  :is_private,   :type =>   Boolean, default: false
  property  :is_open,      :type =>   Boolean, default: false

end