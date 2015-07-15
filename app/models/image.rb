class Image 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property :image,            type: String
  mount_uploader :image,      ImageImageUploader 

  has_one   :in,  :is_owned_by, rel_class: HasImage   # Subject

end
