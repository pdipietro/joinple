class Image 
  include Neo4j::ActiveNode

  include Uuid
  include CreatedAtUpdatedAt

  include IsOwnedBy

  property :name, type: String
  property :description, type: String
  property :url, type: String

end
