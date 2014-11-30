=begin
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">a Generic Social Network engine</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.crowdupcafe.org" property="cc:attributionName" rel="cc:attributionURL">Annalisa Barone & Paolo Di Pietro</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="http://www.crowdupcafe.org" rel="dct:source">http://www.crowdupcafe.org</a>.<br />Permissions beyond the scope of this license may be available at <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.crowdupcafe.org/license" rel="cc:morePermissions">http://www.crowdupcafe.org/license</a>.
=end

class User
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
  validates   :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :email, case_sensitive:false
  validates   :password, length: { minimum: 6 }, allow_blank: true


  # User application rels

  has_many  :out, :users, type: :likes, model_class: false
  has_many  :out, :users, type: :follows, model_class: false
  has_many  :out, :owns, type: :owns, model_class: false

  has_many  :in, :users, origin: :follows

 
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = new_token
    update_attribute(:remember_digest, digest(remember_token))
  end

  # Forgets a user.
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
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  #   def set_last_name
  #      self.last_name = self.last_name.titleize if self.last_name
  #   end
     
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
