class Identit
  include Neo4j::ActiveNode
  property :email
  property :nickname
  has_one :in, :utentes, origin: :identits


  has_one :out, :fornitore, type: 'fornita_da'
end