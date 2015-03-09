module ImageDefinition
  extend ActiveSupport::Concern
  include ImageSizes

  included do
    has_neo4jrb_attached_file :attachment, 
            :path => ":rails_root/public/system/#{@field_name}/:id/:basename_:style.:extension",
            :url => "/system/#{@field_name}/:id/:basename_:style.:extension",
            :styles => @styles,
            :convert_options => @options
    validates_attachment_content_type :attachment, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
    validates_attachment_size :attachment, :less_than_or_equal_to => 4.megabytes
  end

end
