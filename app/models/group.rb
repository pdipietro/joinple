class Group 
  include Neo4j::ActiveNode
  #include ApplicationHelper

  include Uuid
  include CreatedAtUpdatedAt

  include IsOwnedBy

  property  :name,         :type =>   String, presence: true
  property  :description,  :type =>   String
  property  :image,        :type =>   String
  property  :icon,         :type =>   String  
  property  :background_color, :type =>   String, default: "inherit"
  property  :text_color,   :type =>   String, default: "inherit"
  property  :is_open,      :type =>   Boolean, default: false
  property  :is_private,   :type =>   Boolean, default: false


  has_many  :in,  :has_discussion, rel_class: TakesPlaceIn  # Post
  has_many  :in,  :has_member, rel_class: MemberOf       # User
  has_many  :in,  :is_administered_by, model_class: User, origin: :is_admin
  has_many  :in,  :is_followed_by, rel_class: Follows    # User
  has_many  :in,  :likes_to, rel_class: Likes            # :any
  has_one   :out, :belongs_to, rel_class: BelongsTo      # belongs to SocialNetwork
#  has_one   :out, :has_icon, rel_class: IconOf           # Icon

  VALID_RGBA_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates   :name, length: { minimum: 6 }
  validates   :description, length: { minimum: 3 }
  #validates   :image, length: { minimum: 6 }
  #validates   :icon, length: { minimum: 6 }
  #validates   :color, format: { with: VALID_RGBA_REGEX }

#  def self.find_by user
#      PostsController.find user
#  end  

#  def check_current_user
#      is_owned_by = PostsController.get_current_user if is_owned_by.nil?
#  end

end

