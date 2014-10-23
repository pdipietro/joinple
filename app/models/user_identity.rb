class UserIdentity
  include Neo4j::ActiveNode

	include CreatedAtUpdatedAt
	include Uuid

		property	:first_name, type: String
		property	:last_name,	type: String
		property	:nickname,	type: String
		property	:email,	type: String

		def full_name
			first_name & " " & last_name
		end

#    has_one :in,	 :users, origin: :identities
#    has_one :out,	 :providers, type: "is_provided_by"

    has_one :in, :user, origin: :user_identities
#    has_one :out, :provider, type: 'is_provided_by'
    has_one :out, :provider, type: 'is_provided_by'

    #
    # Neo4j.rb needs to have property definitions before any validations. So, the property block needs to come before
    # loading your devise modules.
    #
    # If you add another devise module (such as :lockable, :confirmable, or :token_authenticatable), be sure to
    # uncomment the property definitions for those modules. Otherwise, the unused property definitions can be deleted.
    #

     property :username, :type =>   String
     property :token, :type => String
     index :token

     ## Database authenticatable
     property :email, :type => String, :null => false, :default => ""
     index :email

     property :encrypted_password

     ## If you include devise modules, uncomment the properties below.

     ## Rememberable
     property :remember_created_at, :type => DateTime
     index :remember_token

     ## Recoverable
     property :reset_password_token
     index :reset_password_token
     property :reset_password_sent_at, :type =>   DateTime

     ## Trackable
     property :sign_in_count, :type => Integer, :default => 0
     property :current_sign_in_at, :type => DateTime
     property :last_sign_in_at, :type => DateTime
     property :current_sign_in_ip, :type =>  String
     property :last_sign_in_ip, :type => String

     ## Confirmable
    # property :unconfirmed_email, :type => String
    # property :confirmation_token
    # index :confirmation_token
    # property :confirmed_at, :type => DateTime
    # property :confirmation_sent_at, :type => DateTime

     ## Lockable
     property :failed_attempts, :type => Integer, :default => 0
     property :locked_at, :type => DateTime
     property :unlock_token, :type => String
     index :unlock_token

     ## Token authenticatable
     # property :authentication_token, :type => String, :null => true, :index => :exact

  # Include default devise modules. Others available are:
  # :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :omniauthable # :confirmable,

	# validates	:nickname,   :format => /[-a-zA-Z]{3,30}/

  def self.find_by_provider_and_email(provider, email)
   r=UserIdentity.as(:user_identity).where(:email => email).provider(:provider).where(:name => provider).query.return(:user_identity,:provider)
   r.first
  end

  def self.find_full_identity(provider, email)
#   r=UserIdentity.as(:user_identity).where(:email => email).match(":user<-[:user_identity]->:provider").where(provider.name => provider).query.return(:user,:user_identity,:provider)
  #  match (user:User)--(user_identity:UserIdentity {email : 'paolodipietro58@gmail.com'})-->(provider:Provider {name : 'developer'}) return user, user_identity,provider;
r=Neo4j::Session.query.match("(user:User)--(user_identity:UserIdentity {email : '#{email}'}) optional match (user_identity:UserIdentity)-->(provider:Provider {name : '#{provider}'}) return user, user_identity,provider;")
   r.first
  end

  def self.find_by_provider_and_uid(provider, user)
    Authorization.find(:provider => provider, :user => user)
  end

  def create_full_identity(provider, email, first_name, last_name, nickname)
    prov = Provider.find_by(name:provider)
    puts "Found provider '#{prov}'"

    self.provider = prov
    unless user = User.find_by(first_name:first_name,last_name:last_name,nickname:nickname)
      user = User.create(first_name:first_name,last_name:last_name,nickname:nickname)
    end
    user.user_identities << self
  end

  def authentication ()

  end

end

=begin
  property :token, type: String
  property :secret, type: String
  property :name, type: String
  property :url, type: String

  has_one: :out, :provider, model_class: :provider
  has_one: :out, :user

  def self.find_by_provider_and_uid(provider, user)
    Authorization.find(:provider => provider, :user => user)
  end
=end
