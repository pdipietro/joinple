class User
  include Neo4j::ActiveNode

	include CreatedAtUpdatedAt
	include Uuid

	#	include GroupManagement

		property	:first_name, type: String
		property	:last_name,	type: String
		property	:nickname,	type: String
		property	:email,	type: String


#    property :email, :type => String, :null => false, :default => ""
#    index :email

	#		has_one		:out, :country

	#		has_many	:out, :identity, model_class: Identity
	#		has_many	:out, :language, model_class: Language

	#		has_many	:out, :follows

	#		has_many	:out, :owns, type: :owns, model_class: false
	#		has_many	:out, :likes, type: :likes, model_class: false

	#		has_many	:in,	:groups,	origin: :group, model_class: Group
	#		has_many	:in,	:social_network, model_class: SocialNetwork

		def full_name
			first_name & " " & last_name
		end

    has_many :out, :owns,	origin: :share,  model_class: Share
    has_many :out, :user_identities, type: 'has_identity',  model_class: UserIdentity

  #  has_many :out,  :identities, type: "has_identity"

 #   	validates	:nickname,   :format => /[-a-zA-Z]{3,30}/
 #   	validates	:email,       :format => /the email pattern/

  def self.create_with_omniauth(info)
    create(first_name: info['first_name'])
    if info['last_name'].nil?
      create(last_name: info['name'])
    else
      create(last_name: info['last_name'])
    end
    create(nickname: info['nickname'])
    create(first_name: info['name'])
  end

  def self.find_or_create(first_name, last_name, nickname)
    unless u = User.find_or_create(first_name, last_name, nickname)
      u = User.create(:first_name => first_name, :last_name => last_name, :nickname => nickname)
    end
    puts "New user: #{u.inspect}"
    u
  end

  def self.pop
    u1=User.new
    u1.nickname="mr"
    u1.save

    u2=User.new
    u2.nickname="Gi"
    u2.save

    u3=User.new
    u3.nickname="Cdp"
    u3.save

    u4=User.new
    u4.nickname="PDP"
    u4.save





    i1=UserIdentity.new
    i1.nickname="NBA"
    i1.email="nicola@nicola.it"
    i1.password="12345678"
    i1.save

    puts i1


    i2=UserIdentity.new
    i2.nickname="Gig"
    i2.email="Gi@gi.it"
    i2.password="12345678"
    i2.save

    puts i2

    i3=UserIdentity.new
    i3.nickname="PDP"
    i3.email="pdp@pdp.it"
    i3.password="12345678"
    i3.save

    puts i3

    f1=Provider.new
    f1.name="facebook"
    f1.description="facebook authentication"
    f1.save

    puts f1

    f2=Provider.new
    f2.name="normal"
    f2.description="basic authentication (userid/password/email)"
    f2.save

    puts f2

    f3=Provider.new
    f3.name="google"
    f3.description="google authentication"
    f3.save

    puts f3

    i1.provider = f3
    i2.provider = f1
    i3.provider = f2

    u1.user_identities << i1
    u2.user_identities << i2
    u3.user_identities << i3




  end
end
