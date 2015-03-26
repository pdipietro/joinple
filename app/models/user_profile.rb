class UserProfile 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property :photo,            type: String, default: ""
  mount_uploader :photo,      UserProfilePhotoUploader 

  property :background_color, type: String, default: "inherit"
  property :text_color,       type: String, default: "inherit"
  property :description,      type: String

  has_one  :in,  :belongs_to, rel_class: HasUserProfile, model_class: User   # User

  after_create :set_default

  def self.find_by_user user_id
    puts "self.find_by_user: #{user_id}"
    user_profile = Neo4j::Session.query("match (user:User { uuid : '#{user_id}' })-[has_profile:has_profile]->(profile:UserProfile) return profile").first[0]
    puts "self.find_by_user after: #{user_profile.class.name} - #{user_profile}"
    user_profile
  end

  private

    def set_default
      self.photo = "" if photo.nil?
      self.background_color = "inherit"  if background_color.nil?
      self.text_color = "inherit"  if text_color.nil?
     end
end
