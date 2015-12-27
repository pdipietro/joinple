class Subject
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include SecurePassword

  attr_accessor :remember_token
  attr_accessor :activation_token
  attr_accessor :reset_token

  property :remember_digest,   :type =>  String
  property :activation_digest, :type =>  String
  property :activated,         :type =>  Boolean, default: false
  property :activated_at,      :type =>  DateTime
  property :reset_digest,      :type =>  String
  property :reset_sent_at,     :type =>  DateTime
  property :admin,             :type =>  Boolean, default: false
 
#  before_update :check_default
  before_create :check_default
  before_save :check_default
#  before_save :set_last_name
  before_create :create_activation_digest
 # debugger
 # before_initialize :create_uuid

  property :nickname,    :type =>   String
  property :first_name,  :type =>   String
  property :last_name,   :type =>   String
  property :email,       :type =>   String

  has_secure_password
  property :password_digest

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates   :nickname, :presence => true
  validates_uniqueness_of :nickname, case_sensitive:false
  validates   :first_name, :presence => true
  validates   :last_name, :presence => true
  #validates   :email, presence: true
  validates   :email, format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :email, case_sensitive:false
  validates   :password, length: { minimum: 6 }, allow_blank: true

   # Subject application rels

  has_many  :out, :likes, rel_class: Likes              # :any
  has_many  :out, :follows, rel_class: Follows          # :any
  has_many  :in,  :is_followed_by, rel_class: Follows   # Subject
  has_many  :in,  :use_language, rel_class: Speaks      # Language
  has_many  :out, :owns, rel_class: Owns                # :any
  has_many  :out, :is_member_of, rel_class: MemberOf    # Group
  has_one   :out, :has_profile, rel_class: HasSubjectProfile, model_class: SubjectProfile  # Profile


  #debugger
  #uuid = SecureRandom.uuid if new_record?

  # Remembers a subject in the database for use in persistent sessions.
  def remember
    self.remember_token = new_token
    update_attribute(:remember_digest, digest(remember_token))
  end

  # Forgets a subject.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def check_default
    self.nickname = self.nickname.downcase.gsub(/\s+/, "") if self.nickname
    self.first_name = self.first_name.downcase.titleize.strip.split.join(" ") if self.first_name
    self.last_name = self.last_name.downcase.titleize.strip.split.join(" ") if self.last_name
    self.admin = false if self.admin.nil?
    self.email = self.email.downcase    
  end

  # Returns a random token.
  def new_token
    SecureRandom.urlsafe_base64
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email request_full_path
    SubjectMailer.account_activation(self,request_full_path).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = Subject.new_token
    update_attribute(:reset_digest,  Subject.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email
  def send_password_reset_email
    SubjectMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

 def profile? 
    Subject.has_profile
  end

private

     def create_activation_digest
        self.activation_token  = new_token
        self.activation_digest = digest(self.activation_token)
     end

     def digest(string)
       cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
       BCrypt::Password.create(string, cost: cost)
     end

end
