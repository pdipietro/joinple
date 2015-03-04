class Image 
#  include Neo4j::ActiveNode
#  include Neo4jrb::Paperclip

  def initialize(attr_name)

    measures = { :xs => 1/6, :s => 1/5, :m => 1/4, :l => 1/3, :xl => 1/2, :xxl => 1}

    sizes = {
        :btn         => ['36x36#',     :jpg, :quality => 70],              # user_btn
        :thumb       => ['96x96#',     :jpg, :quality => 70],              # generic thumb (user, post, group, etc.)
        :icon        => ['128x128#',   :jpg, :quality => 70],              # user_icon on left column
        :profile     => ['200x200#',   :jpg, :quality => 70],              # generic profile (user, post, group, etc)
        :original    => ['250>',       :jpg, :quality => 70],              # original image resized
        :banner      => ['854>',       :jpg, :quality => 70],              # banner for generic profile
        :preview     => ['200x400#',   :jpg, :quality => 70],              # preview for post
        :header_l    => ['1280x400>',  :jpg, :quality => 70],              # landing page header
        :header_xl   => ['2560x800>',  :jpg, :quality => 70],              # landing page header
        :logo_l      => ['200x150>',   :jpg, :quality => 70],              # social network logo on a generic page
        :logo_xl     => ['800x600>',   :jpg, :quality => 70],              # social network logo on the landing page 
        :retina      => ['1200>',      :jpg, :quality => 30]               # resize for retina display
      }

    variants = {
        :btn         => [],             
        :thumb       => [],             
        :icon        => [],             
        :logo        => ["l","xl"],      
        :profile     => [],              
        :original    => [],              
        :banner      => [],
        :preview     => [],
        :header      => ["l","xl"], 
      }

      convert_options = {
        :std              => '-set colorspace sRGB -strip',
        :retina           => '-set colorspace sRGB -strip -sharpen 0x0.5'
      }

#      t = 
#        case className
#          when 'SocialNetwork'
#            [ :profile, :logo_l, :logo_xl ]
#          when 'User' 
#            [ :btn, :thumb, :icon, :profile, :original, :retina ]
#          when 'Group', 'Post', 'Discussion' 
#            [ :thumb, :icon, :profile, :original, :banner, :preview, :retina ]        
#          when 'LandingPage' 
#            [ :header_l, :header_xl, :logo_xl, :retina ]
#        end

      styles = Hash.new
      options = Hash.new
      convert = Hash.new
      
=begin
      puts ("attr_name:     #{attr_name}    ----    #{attr_name.class}" )
      puts ("variants:     #{variants} " )
      puts ("variants[#{attr_name}]:     #{variants[attr_name]}   ")
         variants[attr_name].each do |v|
         n1 = "#{attr_name}_#{v}"


          puts ("length(variant):     #{variants[attr_name].length}   ")
          puts ("sizes(n1):     #{sizes[n1.to_sym]} ---- #{n1}   ")
      end
=end

      if variants[attr_name].length == 0
        styles[attr_name.to_sym] = sizes[attr_name] 
        convert[attr_name_to_sym] = attr_name == :retina ? convert_options[attr_name] : convert_options[:std]
      else
        variants[attr_name].each do |v|
          n1 = "#{attr_name}_#{v}"
          styles[n1.to_sym] = sizes[n1.to_sym]
          convert[n1.to_sym] = convert_options[:std]
        end
      end

      @me = " :styles => #{styles},
              :convert_options => #{convert}
              validates_attachment_content_type :#{attr_name}, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
              validates_attachment_size :#{attr_name}, :less_than_or_equal_to => 4.megabytes "

  end

  def me
    @me.strip
  end




end


