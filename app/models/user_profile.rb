class UserProfile 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property :photo,            type: String, default: ""
  mount_uploader :photo,      UserProfilePhotoUploader 

  property :background_color, type: String, default: "#ffffff"
  property :text_color,       type: String, default: "#000000"

  has_one  :in,  :belongs_to, rel_class: HasUserProfile   # User

  after_create :set_default

  private

    def set_default
      self.photo = "" if photo.nil?
      self.background_color = "#ffffff"  if background_color.nil?
      self.text_color = "#000000"  if text_color.nil?
     end
end
