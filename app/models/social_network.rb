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
  property  :goal,                     :type =>   String
  property  :slogan,                   :type =>   String
  property  :short_description,        :type =>   String
  property  :iname,                    :type =>   String
  property  :is_visible,               :type =>   String, default: "open"
  property  :is_online,                :type =>   Boolean, default: false
  property  :status,                   :type =>   String, default: "run"

  #property  :logo,                     type: String
  #property  :banner,                   type: String

  has_many  :in,  :has_posts, model_class: Post, type: "post"                # Posts
  has_many  :in,  :has_tag, model_class: Tag, type: "has_tag"                   # Tags
  has_many  :in,  :has_hashtag, model_class: HashTag, type: "has_hashtag"           # HashTags
  has_many  :out, :has_image, rel_class: HasImage           # Image

  validates   :name, :presence => true, length: { minimum: 2 }, allow_blank: false
  validates_uniqueness_of :name, case_sensitive: false
  validates   :description, length: { minimum: 4 } #, allow_blank: true
  validates   :short_description, length: { minimum: 5, maximum: 40 } #, allow_blank: true
  validates   :goal, length: { minimum: 4 } #, allow_blank: true
  validates   :slogan, :presence => true, length: { minimum: 2 }, allow_blank: false
  validates   :is_visible, inclusion: { in: ["open", "private", "restricted"] }
  validates   :status, inclusion: { in: ["run", "suspended", "locked", "banned"] }

  before_create :check_default
  before_save :check_default

  def check_default
    debugger
    self.uuid = @_uuid
    self.is_online = false if self.is_online
    self.is_visible = "open" if self.is_visible 
    self.status = "run" if self.status 

    self.name = humanize_word(self.name) if self.name 
    self.description = humanize_sentence(self.description) if self.description
    self.short_description = humanize_sentence(self.short_description) if self.short_description
    self.slogan = humanize_sentence(self.slogan) if self.slogan
    self.goal = humanize_word(self.goal) if self.goal
    self.iname = name.gsub(/\s+/, "").downcase unless name.casecmp("joinple") == 0
  end

end
#            .gsub(/\s+/, "")