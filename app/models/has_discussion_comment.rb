class HasPostComment
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  Discussion
  to_class    CommentComment
  type 'has_comment'

end