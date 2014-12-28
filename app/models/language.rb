class Language 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy
  include Description

  property  :code,  :type =>   String

  VALID_LANGUAGE_CODE_REGEX = /\A[a-z]{2,3}(-[a-z]{2,3})?\z/i

  validates   :code, :presence => true, format: { with: VALID_LANGUAGE_CODE_REGEX }
  validates_uniqueness_of :code, case_sensitive:false
  validates   :code, length: { minimum: 2 }, allow_blank: true

  before_create :check_default
  before_save :check_default


  has_many  :in, :is_used_by, type: :speaks, model_class: false
#  has_many  :in, :speaks, origin: :speaks
#  has_many  :out, :is_used_by, type: :speaks, model_class: false
#  has_many  :in, :is_used_by, origin: :speaks

  def check_default
    self.code = self.code.downcase    
  end

end
