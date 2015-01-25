class Group 
  include Neo4j::ActiveNode
  #include ApplicationHelper

  include Uuid
  include CreatedAtUpdatedAt

  include IsOwnedBy

  property  :name,         :type =>   String, presence: true
  property  :description,  :type =>   String
  property  :is_open,      :type =>   Boolean, default: false
  property  :is_private,   :type =>   Boolean, default: false

  has_many  :in,  :has_discussion, rel_class: BelongsTo  # Post
  has_many  :in,  :has_member, rel_class: MemberOf       # User
  has_many  :in,  :is_administered_by, model_class: User, origin: :is_admin
  has_many  :in,  :is_followed_by, rel_class: Follows    # User
  has_many  :in,  :likes_to, rel_class: Likes            # :any
  has_one   :out, :belongs_to, rel_class: BelongsTo      # belongs to Group | SocialNetwork
#  has_one   :out, :has_icon, rel_class: IconOf           # Icon

  validates   :name, length: { minimum: 6 }
  validates   :description, length: { minimum: 3 }

#  def self.find_by user
#      PostsController.find user
#  end  

#  def check_current_user
#      is_owned_by = PostsController.get_current_user if is_owned_by.nil?
#  end

end
