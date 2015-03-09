class Image 
  include Neo4j::ActiveNode
  include Neo4jrb::Paperclip
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy

  def initialize(field_nm, class_nm)
    @class_name= class_nm
    @field_name= field_nm
  end

  def class_name
      @class_name
  end
  def class_name=(val)
      @class_name=val
  end
  def field_name
      @field_name
  end
  def field_name=(val)
      @field_name=val
  end

  @@sizes = {
        :btn         => ['36x36#',     :jpg, :quality => 70],              # user_btn
        :thumb       => ['96x96#',     :jpg, :quality => 70],              # generic thumb (user, post, group, etc.)
        :icon        => ['128x128#',   :jpg, :quality => 70],              # user_icon on left column
        :profile     => ['200x200#',   :jpg, :quality => 70],              # generic profile (user, post, group, etc)
        :original    => ['250>',       :jpg, :quality => 70],              # original image resized
        :banner      => ['854>',       :jpg, :quality => 70],              # banner for generic profile
        :preview     => ['200x400#',   :jpg, :quality => 70],              # preview for post
        :logo        => ['200x150>',   :jpg, :quality => 70],              # social network logo on a generic page

        :xxlarge     => ['5120x1600>', :jpg, :quality => 70],              # landing page header
        :xlarge      => ['2560x800>',  :jpg, :quality => 70],              # landing page header
        :large       => ['1280x400>',  :jpg, :quality => 70],              # landing page header
        :medium      => ['640x200>',   :jpg, :quality => 70],              # landing page header
        :small       => ['320x100>',   :jpg, :quality => 70],              # landing page header
        :xsmall      => ['320x100>',   :jpg, :quality => 70],              # landing page header

        :retina      => ['1200>',      :jpg, :quality => 30]               # resize for retina display
      }

  @@classes = {
      :User           => {
                           :avatar        => [:original, :btn, :thumb, :icon, :profile], 
                           :currentAvatar => [:original, :btn, :thumb, :icon, :profile], 
                           :image         => [:original, :preview]
                         },            
      :Group          => {
                           :logo          => [:original, :btn, :thumb, :icon, :profile], 
                           :header        => [:original, :btn, :thumb, :icon, :profile]
                         },
      :Post           => {
                           :header        => [:original, :banner, :preview]
                         },
      :Discussion     => {
                           :logo          => [:original, :btn, :thumb, :icon, :profile], 
                           :header        => [:original, :banner, :preview]
                         },
      :SocialNetwork  => {
                           :logo          => [:original, :logo, :btn, :icon]    
                         },
      :LandingPage    => {
                           :header        => [:xsmall, :small, :medium, :large, :xlarge, :xxlarge],        
                           :logo          => [:original, :logo]      
                         }
      }

  @@convert_options = {
        :std              => '-set colorspace sRGB -strip',
        :retina           => '-set colorspace sRGB -strip -sharpen 0x0.5'
      }


  has_neo4jrb_attached_file :attachment, 
            :path => ":rails_root/public/system/#{@field_name}/:id/:basename_:style.:extension",
            :url => "/system/#{@field_name}/:id/:basename_:style.:extension",
            :styles => styles,
            :convert_options => converters
  validates_attachment_content_type :attachment, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
  validates_attachment_size :attachment, :less_than_or_equal_to => 4.megabytes


  def styles
    c = Hash.new

    @@classes[class_name][field_name].each do |k|
      c[k] = @@sizes[k] 
    end
    c
  end

  def converters 
    c = Hash.new

    @@classes[class_name][field_name].each do |k|
      c[k] = k == :retina ? @@convert_options[k] : @@convert_options[:std]
    end
    c
  end

end
