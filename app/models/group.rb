class Group 
  include Neo4j::ActiveNode
  property :title, type: String
  property :description, type: String

end
