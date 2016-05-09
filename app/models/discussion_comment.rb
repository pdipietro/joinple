class DiscussionComment
  include Neo4j::ActiveNode
 # include Uuid
  include CreatedAtUpdatedAt
  include Content

  include IsOwnedBy

  has_many  :in,  :likes_to, rel_class: :Likes                  # Subject
  has_many  :in,  :is_followed_by, rel_class: :Follows          # Subject
  has_many  :in,  :is_preferred_by, rel_class: :Preferes
  has_many  :out, :has_tag, rel_class: :HasTag                  # :tag

  has_many  :out, :has_comment, model_class: false, type: "has_comment"     # :DiscussionComment

  property  :images,            type: String

  #has_many  :out, :photo, emoticon, attachment(link) 

end

#  has_one   :out, :belongs_to, model_class: Group,  type: "belongs_to"      # belongs to Group
#  has_many  :out, :has_comment, model_class: DiscussionComment, type: "has_comment"     # :DiscussionComment
