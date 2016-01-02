class MediaManager 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property  :image,            type: String




end
