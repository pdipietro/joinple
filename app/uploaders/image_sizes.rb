class ImageSizes

# ################ COMMENT #############################################################
#
# the size prefixes (sm_, md_, lg_, _xl, _xxl) referso to large and very large devices
# the prefix is calculated at run_time and depends on the phisical size of the screen
#

    DESTINATION = %q["system/uploads/#{ENV['RAILS_ENV']}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"]

    SIZES = {
          :btn         => ['[36, 36]',        :jpg, :quality => 70],              # user_btn
          :sm_logo     => ['[30, 30]',        :jpg, :quality => 70],              # Social network small logo (top bar et other small bars)
          :thumb       => ['[84, 84]',        :jpg, :quality => 70],              # generic thumb (user, post, group, etc.)
          :icon        => ['[128, 128]',      :jpg, :quality => 70],              # user_icon on left column
          :top         => ['[155, 116]',      :jpg, :quality => 70],              # user_icon on left column
          :md_logo     => ['[166, 166]',      :jpg, :quality => 70],              # Social network medium logo (top header near commands
          :profile     => ['[200, 200]',      :jpg, :quality => 70],              # generic profile (user, post, group, etc)
          :original    => ['[250, 0]',        :jpg, :quality => 70],              # original image resized
    
          :post_std    => ['[400, 200]',      :jpg, :quality => 70],              # Post standard is 400x200 on two columns, but can grow
          :post1       => ['[800, 400]',      :jpg, :quality => 70],              # Post standard is 400x200 on two columns, but can grow
          :post2       => ['[600, 300]',      :jpg, :quality => 70],              # Post standard is 400x200 on two columns, but can grow
          :post3       => ['[600, 300]',      :jpg, :quality => 70],              # Post standard is 400x200 on two columns, but can grow
                                                                                  # when the screen si stretched
          :banner      => ['[916,  200]',     :jpg, :quality => 70],              # banner for generic profile
          :sm_banner   => ['[240,  140]',     :jpg, :quality => 70],              # banner for generic profile
          :md_banner   => ['[916,  315]',     :jpg, :quality => 70],              # banner for generic profile
          :md_banner   => ['[1084, 315]',     :jpg, :quality => 70],              # banner for generic profile

          :lg_banner   => ['[1832, 315]',     :jpg, :quality => 70],              # banner for generic profile
          :xl_banner   => ['[2562, 315]',     :jpg, :quality => 70],              # banner for generic profile
          :xxl_banner  => ['[5120, 315]',     :jpg, :quality => 70],              # banner for generic profile
          :logo        => ['[200, 150]',      :jpg, :quality => 70],              # social network logo on a generic page
          :preview     => ['[400, 200]',      :jpg, :quality => 70],              # preview for post
          :cover       => ['[400, 300]',      :jpg, :quality => 70],              # social network logo on a generic page

          :xxlarge     => ['[5120, 1600]',    :jpg, :quality => 70],              # landing page header
          :xlarge      => ['[2560,  800]',    :jpg, :quality => 70],              # landing page header
          :large       => ['[1600,  400]',    :jpg, :quality => 70],              # landing page header
          :medium      => ['[1280,  400]',    :jpg, :quality => 70],              # landing page header
          :small       => ['[640,   200]',    :jpg, :quality => 70],              # landing page header
          :xsmall      => ['[320,   100]',    :jpg, :quality => 70],              # landing page header

          :retina      => ['[1200, -1]',    :jpg, :quality => 30]                 # resize for retina display
        }

    CLASSES = {
        :Article        => {
                             :logo          => [:banner, :preview, :btn, :thumb, :icon, :profile, :logo, :xsmall, :small, :medium, :large, :xlarge, :xxlarge]
                           },
        :UserProfile    => {
                             :photo         => [:btn, :thumb, :icon, :profile] 
                           },            
        :Image          => {
                             :image         => [:preview, :profile, :cover, :banner]
                           },            
        :Group          => {
                             :logo          => [:btn, :thumb, :icon, :profile], 
                             :header        => [:btn, :thumb, :icon, :profile, :sm_banner, :md_banner, :lg_banner, :xl_banner]# , :xxl_banner]
                           },
        :Post           => {
                             :header        => [:post_std, :post1, :post2, :post3, :sm_logo]
                           },
        :Discussion     => {
                             :logo          => [:btn, :thumb, :icon, :profile], 
                             :header        => [:banner, :preview]
                           },
        :SocialNetwork  => {
                             :logo          => [:logo, :btn, :icon, :cover, :top],    
                             :logo_social   => [:thumb, :sm_logo, :md_logo]    
                           },
        :LandingPage    => {
                             :header        => [:xsmall, :small, :medium, :large],  # :xlarge, :xxlarge],        
                             :logo          => [:logo]      
                           }
        }

    CONVERT_OPTIONS = {
          :std              => '-set colorspace sRGB -strip',
          :retina           => '-set colorspace sRGB -strip -sharpen 0x0.5'
        }

    SCREEN_WIDTH = [
          [0,       360, 640, 768,1024, 1280,1440,1600,1920,   2560,  99999],
          ["none","xxs","xs","sm","md","std","lg","xl","xxl","xxxl","xxxxl"]
        ]

    SCREEN_WIDTH2 = {
            :none     =>     0,
            :xxs      =>   360,
            :xs       =>   640,
            :sm       =>   768,
            :md       =>  1024,
            :std      =>  1280,
            :lg       =>  1440,
            :xl       =>  1600,
            :xxl      =>  1920,
            :xxxl     =>  2560,
            :xxxxl    => 99999
          }

    RESIZABLE = [[:LandingPage,:header,:full], [:Group,:header,:central], [:Discussion,:header,:central], [:Post,:header,:central]]

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

    def initialize(class_name,field_name)
        version :btn do
          process :resize_to_fit => [36, 36]
        end
    end

    LEFT_COLUMN_WIDTH = 178;
    RIGHT_COLUMN_WIDTH = 178;
    STANDARD_PADDING = 4;
    CENTRAL_WIDTH = LEFT_COLUMN_WIDTH + RIGHT_COLUMN_WIDTH + 2 * STANDARD_PADDING;

    def self.compute_full_image_size (phisical_size)
        SCREEN_WIDTH2.detect { |k,v| v > phisical_size }[0].to_s
     end

    def self.compute_salvattore_size (columns, phisical_size, pixelRatio)
        logical_size = ( phisical_size - CENTRAL_WIDTH ) / ( columns - 1 );
        SCREEN_WIDTH2.detect { |k,v| v > logical_size }[0].to_s
    end

end
