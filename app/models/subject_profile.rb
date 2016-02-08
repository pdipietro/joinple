class SubjectProfile 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  # attr_accessor :photo

  property :background_color, type: String, default: 'inherit'
  property :text_color,       type: String, default: 'inherit'
  property :description,      type: String

  has_one  :in, :belongs_to, rel_class: :HasSubjectProfile, model_class: :Subject # Subject
  has_many :out, :has_image, rel_class: :HasImage, model_class: :Image

  after_create :set_default

  def photo(subject)
    a_subject = subject.nil? ? belongs_to : subject
    image = has_image(:i, :r).where('r.type = {photo}').params(photo: 'photo').first(:i)
    image.nil? ? 'b2833539-1e64-49f9-be8a-1a74509dce6e' : "subject/#{a_subject.uuid}/#{image.uuid}"
  end

  private

    def set_default
      self.background_color = 'inherit' if background_color.nil?
      self.text_color = 'inherit' if text_color.nil?
    end
end
