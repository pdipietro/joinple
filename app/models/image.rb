class Image 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property  :type,             :type =>   String
  
  has_many  :in,  :is_image_of, rel_class: :any   
end
