class Discussion 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property  :title,           type: String
  property  :description,     type: String
  property  :background_color,         :type =>   String, default: "inherit"


  has_many  :in,  :likes_to, rel_class: Likes                  # User
  has_many  :in,  :is_followed_by, rel_class: Follows          # User
  has_many  :in,  :is_preferred_by, rel_class: Preferes
  has_many  :out, :has_tag, rel_class: HasTag                  # :tag
  has_one   :in,  :is_owned_by, rel_class: Owns                # User

  property  :header,              type: String
  mount_uploader :header,         DiscussionHeaderUploader 

  has_one   :out, :belongs_to, model_class: Group       # belongs to Group
  has_many  :out, :has_comment, model_class: DiscussionComment, type: "has_comment"     # :DiscussionComment

  validates   :title, :presence => true
  validates   :title, length: { minimum: 6 }
  validates   :description, length: { minimum: 10 }, allow_blank: true

end
