class Search 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt

  property  :text,           type: String

end
