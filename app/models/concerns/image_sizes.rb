module ImageSizes
  extend ActiveSupport::Concern

  included do

    SIZES = {
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

    CLASSES = {
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

    CONVERT_OPTIONS = {
          :std              => '-set colorspace sRGB -strip',
          :retina           => '-set colorspace sRGB -strip -sharpen 0x0.5'
        }

    def styles(class_name, field_name)
      c = Hash.new

      CLASSES[class_name][field_name].each do |k|
        c[k] = SIZES[k] 
      end
      c
    end

    def options (class_name, field_name)
      c = Hash.new

      CLASSES[class_name][field_name].each do |k|
        c[k] = k == :retina ? CONVERT_OPTIONS[k] : CONVERT_OPTIONS[:std]
      end
      c
    end

  end


end
