class SocialNetwork 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy
  include Name
  include Description

  property  :goal,             :type =>   String
  property  :background_color, :type =>   String, default: "inherit"
  property  :text_color,       :type =>   String, default: "inherit"
  property  :slogan,           :type =>   String

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
  validates   :goal, length: { minimum: 4 } #, allow_blank: true
  validates   :slogan, :presence => true, length: { minimum: 2 }, allow_blank: false

  before_create :check_default
  before_save :check_default

  def check_default
    self.name = humanize_word(self.name).gsub(/\s+/, "") if self.name 
    self.description = humanize_sentence(self.description) if self.description
    self.goal = humanize_word(self.goal) if self.goal    
  end

end
