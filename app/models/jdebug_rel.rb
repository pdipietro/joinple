class Jdebug 
  include Neo4j::ActiveRel

  from_class :Jdebug
  to_class :Jdebug
  type 'call'

  property :order, type: :Integer
end