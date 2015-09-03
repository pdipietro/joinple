class MailCollector 
  include Neo4j::ActiveNode

  include Uuid
  include CreatedAtUpdatedAt

  before_create :check_default
  before_save :check_default

  #geocoded_by :ip_address, :latitude => :lat, :longitude => :lon
  #after_validation :geocode

  property :email, type: String
  property :privacy_accepted, type: Boolean
  property :ip_address, type: String
  property :lat
  property :lon

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates   :email, presence: true
  validates   :email, format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :email, case_sensitive:false
  validates   :privacy_accepted, presence: true
  validates   :privacy_accepted, inclusion: { in: ["true"] }

  def check_default
    self.email = self.email.downcase    
  end

end

