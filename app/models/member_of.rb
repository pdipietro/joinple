class MemberOf
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  Subject
  to_class    :any
  type 'is_member_of'

  property  :is_admin,   :type =>   Boolean, default: false
  property  :can_write,  :type =>   Boolean, default: true

end