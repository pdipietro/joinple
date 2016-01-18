class Group 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy

  property  :name,         :type =>   String, presence: true
  property  :description,  :type =>   String
  property  :background_color, :type =>   String, default: "inherit"
  property  :text_color,   :type =>   String, default: "inherit"
  property  :type,         :type =>   String, default: "open"

  property  :logo,              type: String
  property  :banner,            type: String

  has_many  :in,  :has_discussion, rel_class: :TakesPlaceIn  # Post
  has_many  :in,  :has_member, rel_class: :MemberOf       # Subject
  has_many  :in,  :is_administered_by, model_class: :Subject, origin: :is_admin
  has_many  :in,  :is_followed_by, rel_class: :Follows    # Subject
  has_many  :in,  :likes_to, rel_class: :Likes            # :any
  has_many  :out, :has_tag, rel_class: :HasTag            # :tag
  has_one   :out, :belongs_to, rel_class: :BelongsTo      # belongs to SocialNetwork


  VALID_RGBA_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates   :name, length: { minimum: 6 }
  validates   :description, length: { minimum: 3 }
  # validates_uniqueness_of :name, case_sensitive:false
  validates   :type, inclusion: { in: ["open", "closed", "secret"] }
  #validates   :image, length: { minimum: 6 }
  #validates   :icon, length: { minimum: 6 }
  #validates   :color, format: { with: VALID_RGBA_REGEX }

#  def self.find_by subject
#      PostsController.find subject
#  end  

#  def check_current_subject
#      is_owned_by = PostsController.get_current_subject if is_owned_by.nil?
#  end

  def style
    "background-color: #{self.background_color}; color: #{self.text_color};"
  end


end

