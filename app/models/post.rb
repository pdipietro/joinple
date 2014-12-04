class Post 
  include Neo4j::ActiveNode

  include Uuid
  include CreatedAtUpdatedAt
  include Content

  include IsOwnedBy
  include IsFollowedBy
  include IsLikedBy

  before_create :set_owner
 
  property  :title,  :type =>   String, presence: true

  has_many  :out, :posts, type: :has_post, model_class: Post
  has_one   :in,  :posts, type: :parent, model_class: Post

  def self.find_by user
      PostsController.find user
  end  

end