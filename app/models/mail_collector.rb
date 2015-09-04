class MailCollector 
  include Neo4j::ActiveNode
  include Neo4j::ActiveNode::Spatial
  
  include Uuid
  include CreatedAtUpdatedAt

  #spatial_index 'mailcollectors'
  #property :ip_address, type: String
  #property :lat
  #property :lon
  
  TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE'].to_set  

  before_create :check_default
  before_save :check_default

  #geocoded_by :ip_address, :latitude => :lat, :longitude => :lon
  #after_validation :geocode

  property :email, type: String
  property :privacy_accepted, type: Boolean, default: false
  property :ip_address, type: String
  property :lat
  property :lon

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates   :email, presence: true
  validates   :email, format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :email, case_sensitive:false
  validates   :privacy_accepted, presence: true
  validates   :privacy_accepted, inclusion: { in: TRUE_VALUES }

  def check_default
    self.email = self.email.downcase    
  end

end

