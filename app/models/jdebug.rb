class Jdebug 
  include Neo4j::ActiveNode

  property :name, 	type: :String

  has_many  :in,  :is_called_by, rel_class: :JdebugRel
  has_many  :out, :returns_to, rel_class: :JdebugRel
end
