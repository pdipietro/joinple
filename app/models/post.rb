class Post 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include Content

  has_many  :in,  :likes_to, rel_class: Likes                  # User
  has_many  :in,  :is_followed_by, rel_class: Follows          # User
  has_many  :in,  :is_preferred_by, rel_class: Preferes
  has_many  :out, :has_tag, rel_class: HasTag                  # :tag
  has_one   :in,  :is_owned_by, rel_class: Owns                # User

  has_one   :out, :belongs_to, model_class: SocialNetwork       # belongs to SocialNetwork
  has_many  :out, :has_comments, rel_class: HasPostComment      # :comment

  property  :header,            type: String
  mount_uploader :header,       PostHeaderUploader 

  def self.find_by user
      PostsController.find user
  end  

  def check_current_user
      is_owned_by = PostsController.get_current_user if is_owned_by.nil?
  end


end
