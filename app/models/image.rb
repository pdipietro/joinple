class Image 
  include Neo4j::ActiveNode
  include Neo4jrb::Paperclip
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy
  include ImageSizes

  def initialize(class_name,field_name)
    @styles = styles(class_name, field_name)
    @options = options(class_name, field_name)
  end

  has_one :in, :is_image_of, rel_class: HasImage 
  
  include ImageDefinition

end
