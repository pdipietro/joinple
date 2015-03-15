class SocialNetwork 
  include Neo4j::ActiveNode
#  include Neo4jrb::Paperclip
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy
  include Name
  include Description

  property  :goal,  :type =>   String

  validates   :name, :presence => true, length: { minimum: 3 }
  validates_uniqueness_of :name, case_sensitive: false
  validates   :description, length: { minimum: 4 } #, allow_blank: true
  validates   :goal, length: { minimum: 4 } #, allow_blank: true

  before_create :check_default
  before_save :check_default

=begin
  #has_many    out, :banners, :has_image 
  has_neo4jrb_attached_file :banner,
    :path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
    :url => "/system/:attachment/:id/:basename_:style.:extension",
    :styles => {
      :thumb    => ['126x126#',  :jpg, :quality => 70],
      :preview  => ['480x480#',  :jpg, :quality => 70],
      :retina   => ['126>',      :jpg, :quality => 30]
  },
  :convert_options => {
    :thumb    => '-set colorspace sRGB -strip',
    :preview  => '-set colorspace sRGB -strip',
    :large    => '-set colorspace sRGB -strip',
    :retina   => '-set colorspace sRGB -strip -sharpen 0x0.5'
  }
  validates_attachment_content_type :banner, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
=end
  def check_default
    self.name = humanize_word(self.name) if self.name    
    self.description = humanize_sentence(self.description) if self.description
    self.goal = humanize_word(self.goal) if self.goal    
  end

end
