class Test 
  include Neo4j::ActiveNode
  include Uuid
  include CreatedAtUpdatedAt
  include IsOwnedBy
  include Description

  has_one   :out, :cover, rel_class: HasImage            # Icon

end
