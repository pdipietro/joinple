class Group 
  include Neo4j::ActiveNode
  #include ApplicationHelper
  include Neo4jrb::Paperclip

  include Uuid
  include CreatedAtUpdatedAt

  include IsOwnedBy

  property  :name,         :type =>   String, presence: true
  property  :description,  :type =>   String
  property  :image,        :type =>   String
  property  :icon,         :type =>   String  
  property  :background_color, :type =>   String, default: "inherit"
  property  :text_color,   :type =>   String, default: "inherit"
  property  :is_open,      :type =>   Boolean, default: false
  property  :is_private,   :type =>   Boolean, default: false


  has_many  :in,  :has_discussion, rel_class: TakesPlaceIn  # Post
  has_many  :in,  :has_member, rel_class: MemberOf       # User
  has_many  :in,  :is_administered_by, model_class: User, origin: :is_admin
  has_many  :in,  :is_followed_by, rel_class: Follows    # User
  has_many  :in,  :likes_to, rel_class: Likes            # :any
  has_many  :out, :has_tag, rel_class: HasTag            # :tag
  has_one   :out, :belongs_to, rel_class: BelongsTo      # belongs to SocialNetwork

#  has_one   :out, :has_icon, rel_class: IconOf           # Icon

  has_neo4jrb_attached_file :cover,
    :path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
    :url => "/system/:attachment/:id/:basename_:style.:extension",
    :styles => {:thumb => ["96x96#", :jpg, {:quality => 70}], :icon => ["128x128#", :jpg, {:quality => 70}], :profile => ["200x200#", :jpg, {:quality => 70}] },
              :convert_options => {"thumb" => "-set colorspace sRGB -strip", "icon"=>"-set colorspace sRGB -strip", "profile"=>"-set colorspace sRGB -strip"}
              validates_attachment_content_type :cover, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
              validates_attachment_size :cover, :less_than_or_equal_to => 4.megabytes 

=begin
  has_neo4jrb_attached_file :cover,
  :path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
  :url => "/system/:attachment/:id/:basename_:style.:extension",
  :styles => {
    :thumb    => ['126x126#',  :jpg, :quality => 70],
    :preview  => ['480x480#',  :jpg, :quality => 70],
    :normal   => ['823x250>',  :jpg, :quality => 70],
    :large    => ['600>',      :jpg, :quality => 70],
    :retina   => ['1200>',     :jpg, :quality => 30]
  },
  :convert_options => {
    :thumb    => '-set colorspace sRGB -strip',
    :preview  => '-set colorspace sRGB -strip',
    :normal   => '-set colorspace sRGB -strip',
    :large    => '-set colorspace sRGB -strip',
    :retina   => '-set colorspace sRGB -strip -sharpen 0x0.5'
  }
  validates_attachment_content_type :cover, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
=end

  VALID_RGBA_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates   :name, length: { minimum: 6 }
  validates   :description, length: { minimum: 3 }
  #validates   :image, length: { minimum: 6 }
  #validates   :icon, length: { minimum: 6 }
  #validates   :color, format: { with: VALID_RGBA_REGEX }

#  def self.find_by user
#      PostsController.find user
#  end  

#  def check_current_user
#      is_owned_by = PostsController.get_current_user if is_owned_by.nil?
#  end

end

