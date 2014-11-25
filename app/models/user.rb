=begin
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">a Generic Social Network engine</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.crowdupcafe.org" property="cc:attributionName" rel="cc:attributionURL">Annalisa Barone & Paolo Di Pietro</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="http://www.crowdupcafe.org" rel="dct:source">http://www.crowdupcafe.org</a>.<br />Permissions beyond the scope of this license may be available at <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.crowdupcafe.org/license" rel="cc:morePermissions">http://www.crowdupcafe.org/license</a>.
=end

class User
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include SecurePassword
  before_save :set_first_name
  before_save :set_last_name

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
  validates   :password, length: { minimum: 6 }


  # User application rels

  has_many  :out, :users, type: :likes, model_class: false
  has_many  :out, :users, type: :follows, model_class: false
  has_many  :out, :users, type: :owns, model_class: false

  has_many  :in, :users, origin: :follows

  private

    def set_first_name
      self.first_name = self.first_name.titleize if self.first_name
    end

   def set_last_name
      self.last_name = self.last_name.titleize if self.last_name
    end

end
