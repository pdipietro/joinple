class Hashtag 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property  :tag,         :type =>   String, presence: true

  VALID_TAG_REGEX = /\A[a-zA-Z0-9\-]+\z/i

  validates_uniqueness_of :tag, case_sensitive:false
  validates   :tag, format: { with: VALID_TAG_REGEX, message: "Tag can contain only characters, numbers and hyphen" }
  validates   :tag, length: { minimum: 3, message: "minimum tag length is 3" }

end
