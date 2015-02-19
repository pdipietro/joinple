class Tag 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property  :tag,         :type =>   String, presence: true
  property  :description, :type =>   String
  property  :see_also,    :type =>   String

  has_one   :out,  :language, rel_class: HasLanguage      # Language
  has_many  :in,   :is_used_by, rel_class: HasTag         # Tag

  has_many  :both, :translate,     rel_class: Translate      # Translate
  has_many  :both, :synonyms,      rel_class: TagConnection  # Tag synonims
  has_many  :both, :antonyms,      rel_class: TagConnection  # Tag antonyms

  before_create :check_default
  before_save :check_default

  VALID_TAG_REGEX = /\A[a-z0-9\-]+\z/i

  validates_uniqueness_of :tag, case_sensitive:false
  validates   :tag, format: { with: VALID_TAG_REGEX, message: "Tag can contain only lowercase characters, numbers and hyphen" }
  validates   :tag, length: { minimum: 3, message: "minimum tage length is 3" }

  def check_default
    self.tag = self.tag.downcase if self.first_name
  end

end
