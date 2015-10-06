class PostComment 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include Content

  include IsOwnedBy

  has_many  :in,  :likes_to, rel_class: Likes                  # Subject
  has_many  :in,  :is_followed_by, rel_class: Follows          # Subject
  has_many  :in,  :is_preferred_by, rel_class: Preferes
  has_many  :out, :has_tag, rel_class: HasTag                  # :tag

  has_one   :in, :belongs_to, model_class: Post, type: "belongs_to"  # belongs to Post

  property  :image,            type: String
  #mount_uploader :image,       PostCommentImageUploader 

end
