class SubjectProfile 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property :photo,            type: String, default: ""
  #mount_uploader :photo,      SubjectProfilePhotoUploader 

  property :background_color, type: String, default: "inherit"
  property :text_color,       type: String, default: "inherit"
  property :description,      type: String

  has_one  :in,  :belongs_to, rel_class: HasSubjectProfile, model_class: Subject   # Subject

  after_create :set_default

  private

    def set_default
      self.photo = "" if photo.nil?
      self.background_color = "inherit"  if background_color.nil?
      self.text_color = "inherit"  if text_color.nil?
     end

end
