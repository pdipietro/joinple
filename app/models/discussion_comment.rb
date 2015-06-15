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

  has_one   :in, :belongs_to, type: "belongs_to", model_class: false  # belongs to Discussion|DiscussionComment
  has_many  :out, :has_comment, model_class: DiscussionComment, type: "has_comment"     # :DiscussionComment

  property  :images,            type: String
  mount_uploader :images,       DiscussionCommentImageUploader 


  #has_many  :out, :photo, emoticon, attachment(link) 

end

 