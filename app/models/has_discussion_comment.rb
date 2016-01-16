class HasDiscussionComment
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  :Discussion
  to_class    :DiscussionComment
  type 'has_comment'

end