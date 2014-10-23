class Utente
  include Neo4j::ActiveNode
  property :nickname
  has_many :out, :identits, type: 'has'

  #  has_one :in, :has_identity, model_class: User

end