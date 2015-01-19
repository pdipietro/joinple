class Language 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy
  include Description

  property  :code,  :type =>   String

  VALID_LANGUAGE_CODE_REGEX = /\A[a-z]{2}(-[a-z]{2})?\z/i

  # validates   :code, :presence => true
  validates   :code, format: { with: VALID_LANGUAGE_CODE_REGEX, message: "Invalid format. Must be a 2 chars language code (ISO 639-1), optionally followed by an hyphen and a 2 chars country-code" }
  validates_uniqueness_of :code, case_sensitive: false
  # validates   :code, length: { minimum: 2 } #, allow_blank: true
  validates_uniqueness_of :description, case_sensitive: false

  before_create :check_default
  before_save :check_default

  has_many  :out, :is_spoken_by, rel_class: Speaks

  def check_default
    self.code = self.code.downcase    
    self.description = humanize_word(self.description) if self.description
  end

end
