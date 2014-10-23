class Fornitore
  include Neo4j::ActiveNode
  property :name
  property :description
  has_many :in, :identits, origin: :fornitore

  def self.pop
    u1=Utente.new
    u1.nickname="mr"
    u1.save

    u2=Utente.new
    u2.nickname="Gi"
    u2.save

    u3=Utente.new
    u3.nickname="Cdp"
    u3.save

    u4=Utente.new
    u4.nickname="PDP"
    u4.save



    i1=Identit.new
    i1.nickname="NB"
    i1.email="nicola@nicola.it"
    i1.save


    i2=Identit.new
    i2.nickname="Gi"
    i2.email="Gi@gi.it"
    i2.save

    i3=Identit.new
    i3.nickname="PDP"
    i1.email="pdp@pdp.it"
    i3.save


    f1=Fornitore.new
    f1.name="facebook"
    f1.save

    f2=Fornitore.new
    f2.name="normal"
    f2.save

    f3=Fornitore.new
    f3.name="google"
    f3.save

    puts i1.class
    puts i1.utentes
    puts Utente.all

    u1.identits << i1
    u2.identits << i2
    u3.identits << i3

    i1.fornitore = f3
    i2.fornitore = f1
    i3.fornitore = f2




  end
end