class Post 
  include Neo4j::ActiveNode
  #include ApplicationHelper

  include Uuid
  include CreatedAtUpdatedAt
  include Content

  include IsOwnedBy
  include IsFollowedBy
  include LikesTo

  property  :title,  :type =>   String, presence: true

  has_many  :out, :child, type: :has_post, model_class: Post
  has_one   :in,  :parent, type: :has_post, model_class: Post


  def self.find_by user
      PostsController.find user
  end  

  def check_current_user
      is_owned_by = PostsController.get_current_user if is_owned_by.nil?
  end


end
