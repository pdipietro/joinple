class DiscussionComment
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include Content

  include IsOwnedBy

  has_many  :in,  :likes_to, rel_class: Likes                  # User
  has_many  :in,  :is_followed_by, rel_class: Follows          # User
  has_many  :in,  :is_preferred_by, rel_class: Preferes
  has_many  :out, :has_tag, rel_class: HasTag                  # :tag

  property  :images,            type: String
  mount_uploader :images,       DiscussionCommentImageUploader 

  has_one   :out, :belongs_to, model_class: :Any #[:Discussion, :DiscussionComment]           # belongs to Group
  has_many  :out, :has_comments, rel_class: HasDiscussionComment      # :comment

  #has_many  :out, :photo, emoticon, attachment(link) 

end
