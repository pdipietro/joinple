class UserProfile 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property :photo,            type: String
  mount_uploader :photo,      UserProfilePhotoUploader 

  property :backgroud_color,  type: String
  property :text_color,       type: String

  has_one  :in,  :belongs_to, rel_class: HasProfile   # User

end
