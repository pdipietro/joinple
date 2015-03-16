class LandingPage 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
 
  property    :description,  :type =>  String
  validates   :description, length: { minimum: 150 }, allow_blank: true

  has_many    :out, :header, relClass: HasImage
  has_one     :out, :logo, relClass: HasImage

=begin
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
=end    
end
