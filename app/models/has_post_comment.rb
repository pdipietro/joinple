class HasPostComment
  include Neo4j::ActiveRel
  include CreatedAtUpdatedAt

  from_class  Post
  to_class    PostComment
  type 'has_comment'

end