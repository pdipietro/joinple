class SocialNetwork 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy
  include Name
  include Description

  property  :goal,  :type =>   String

  validates   :name, :presence => true, length: { minimum: 3 }
  validates_uniqueness_of :name, case_sensitive: false
  validates   :description, length: { minimum: 4 } #, allow_blank: true
  validates   :goal, length: { minimum: 4 } #, allow_blank: true

  before_create :check_default
  before_save :check_default

  def check_default
    self.name = humanize_word(self.name) if self.name    
    self.description = humanize_sentence(self.description) if self.description
    self.goal = humanize_word(self.goal) if self.goal    
  end

end
