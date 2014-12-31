class Post 
  include Neo4j::ActiveNode
  #include ApplicationHelper

  include Uuid
  include CreatedAtUpdatedAt
  include Content

  include IsOwnedBy

  property  :title,  :type =>   String, presence: true

  has_many  :in,  :likes_to, rel_class: Likes                  # User
  has_many  :in,  :is_followed_by, rel_class: Follows          # User
  has_many  :in,  :is_preferred_by, rel_class: Preferes

  has_one   :out, :belongs_to, rel_class: BelongsTo   # belongs to Post | Group | SocialNetwork


  def self.find_by user
      PostsController.find user
  end  

  def check_current_user
      is_owned_by = PostsController.get_current_user if is_owned_by.nil?
  end


end
