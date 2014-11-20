=begin
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">a Generic Social Network engine</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.crowdupcafe.org" property="cc:attributionName" rel="cc:attributionURL">Annalisa Barone & Paolo Di Pietro</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="http://www.crowdupcafe.org" rel="dct:source">http://www.crowdupcafe.org</a>.<br />Permissions beyond the scope of this license may be available at <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.crowdupcafe.org/license" rel="cc:morePermissions">http://www.crowdupcafe.org/license</a>.
=end

class User
  include Neo4j::ActiveNode

  # User application rels

    has_many  :out, :users, type: :likes, model_class: false
    has_many  :out, :users, type: :follows, model_class: false
    has_many  :out, :users, type: :owns, model_class: false

    has_many  :in, :users, origin: :follows

    #
    # Neo4j.rb needs to have property definitions before any validations. So, the property block needs to come before
    # loading your devise modules.
    #
    # If you add another devise module (such as :lockable, :confirmable, or :token_authenticatable), be sure to
    # uncomment the property definitions for those modules. Otherwise, the unused property definitions can be deleted.
    #

     property :name, :type =>   String
     property :token, :type => String
     index :token
     index :name

     property :created_at, :type => DateTime
     property :updated_at, :type => DateTime

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
     # property :confirmation_token
     # index :confirmation_token
     # property :confirmed_at, :type => DateTime
     # property :confirmation_sent_at, :type => DateTime

     ## Lockable
     #  property :failed_attempts, :type => Integer, :default => 0
     # property :locked_at, :type => DateTime
     #  property :unlock_token, :type => String,
     # index :unlock_token

     ## Token authenticatable
     # property :authentication_token, :type => String, :null => true, :index => :exact

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
         #, :token_authenticatable

  has_many  :out, :authorizations, type: :is_autorized_by, :dependent => :destroy
  has_many  :out, :shares, type: :shares
  has_many  :in, :users, from: :shares

  # User application attributes

  has_many  :out, :users, type: :likes, model_class: false
  has_many  :out, :users, type: :follows, model_class: false
  has_many  :out, :users, type: :owns, model_class: false

  has_many  :in, :users, origin: :follows

end
