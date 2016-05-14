class Post 
  include Neo4j::ActiveNode
 # include Uuid
  include CreatedAtUpdatedAt
  include Content

  has_many  :in,  :likes_to, rel_class: :Likes                  # Subject
  has_many  :in,  :is_followed_by, rel_class: :Follows          # Subject
  has_many  :in,  :is_preferred_by, rel_class: :Preferes
  has_many  :out, :has_tag, rel_class: :HasTag                  # :tag
  has_one   :in,  :is_owned_by, rel_class: :Owns                # Subject

  has_one   :out, :belongs_to, model_class: :SocialNetwork , type: "belongs_to"      # belongs to SocialNetwork
  has_many  :out, :has_comment, model_class: :PostComment, type: "has_comment"     # :comment

  #property  :image,              type: String, default: nil                       

  property  :image0,             type: String, default: nil                       
  property  :image1,             type: String, default: nil                       
  property  :image2,             type: String, default: nil                       
  property  :image3,             type: String, default: nil                       
  property  :image4,             type: String, default: nil                       

  def self.find_by subject
      PostsController.find subject
  end  

  def check_current_subject
      is_owned_by = PostsController.get_current_subject if is_owned_by.nil?
  end

end
