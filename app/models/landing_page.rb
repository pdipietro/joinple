class LandingPage 
  include Neo4j::ActiveNode
  include Neo4jrb::Paperclip
  include Uuid
  include CreatedAtUpdatedAt

  property    :description,  :type =>   String
  validates   :description, length: { minimum: 150 }, allow_blank: true

=begin
  # **************** this block must return directly the attachment definition
  #                  at themoment after running, it must be copied from th debug window to the class def
  #
  img_header = Image.new :header
  puts ("#{img_header.me}")
  img_logo = Image.new :logo
  puts ("#{img_logo.me}")
=end


  has_neo4jrb_attached_file :header,
    :path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
    :url => "/system/:attachment/:id/:basename_:style.:extension",
    :styles => { :header_l => ["1280x400", :jpg, {:quality => 70}], :header_xl => ["2560x800", :jpg, {:quality => 70}] },
              :convert_options => {"header_l" => "-set colorspace sRGB -strip", "header_xl"=>"-set colorspace sRGB -strip"}
              validates_attachment_content_type :header, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
#              validates_attachment_size :header, :less_than_or_equal_to => 4.megabytes

  has_neo4jrb_attached_file :logo, 
    :path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
    :url => "/system/:attachment/:id/:basename_:style.:extension",
    :styles => { :logo_l => ["200x150", :jpg, {:quality=>70}], :logo_xl => ["800x600", :jpg, {:quality => 70}]},
              :convert_options => {"logo_l" => "-set colorspace sRGB -strip", "logo_xl"=>"-set colorspace sRGB -strip"}
              validates_attachment_content_type :logo, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
#              validates_attachment_size :logo, :less_than_or_equal_to => 4.megabytes
    
end
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