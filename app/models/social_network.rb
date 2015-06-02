class SocialNetwork 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy
  include Name
  include Description

  property  :background_color,         :type =>   String, default: "#e5e5e5"
  property  :social_network_color,     :type =>   String, default: "#000000"
  property  :text_color,               :type =>   String, default: "#323342"
  property  :mission,                  :type =>   String
  property  :slogan,                   :type =>   String
  property  :short_description,        :type =>   String
  property  :iname,                    :type =>   String

  property  :logo,              type: String
  mount_uploader :logo,         SocialNetworkLogoUploader 
  property  :logo_social,       type: String
  mount_uploader :logo_social,  SocialNetworkLogoSocialUploader 

  has_many  :in,  :has_posts, model_class: Post                # Posts
  has_many  :in,  :has_tag, model_class: Tag                   # Tags
  has_many  :in,  :has_hashtag, model_class: HashTag           # HashTags

  validates   :name, :presence => true, length: { minimum: 2 }, allow_blank: false
  validates_uniqueness_of :name, case_sensitive: false
  validates   :description, length: { minimum: 4 } #, allow_blank: true
  validates   :short_description, length: { minimum: 5, maximum: 40 } #, allow_blank: true
  validates   :mission, length: { minimum: 4 } #, allow_blank: true
  validates   :slogan, :presence => true, length: { minimum: 2 }, allow_blank: false

  before_create :check_default
  before_save :check_default

  def check_default
    self.name = humanize_word(self.name) if self.name 
    self.description = humanize_sentence(self.description) if self.description
    self.short_description = humanize_sentence(self.short_description) if self.short_description
    self.slogan = humanize_sentence(self.slogan) if self.slogan
    self.mission = humanize_word(self.mission) if self.mission
    self.iname = name.gsub(/\s+/, "")  
  end

end
#            .gsub(/\s+/, "")