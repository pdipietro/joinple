module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.full_name, class: "gravatar")
  end

#  def full_name(user)
#  def User.full_name
#    "#{user.first_name} #{user.last_name}"
#  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def activated?
    true
  end

  def followers(uuid)
     Neo4j::Session.query("match (follower:User)-[r:follows]->(:User { uuid : '#{uuid}'}) return follower")
  end

  def followings(uuid)
     Neo4j::Session.query("match (following:User)<-[r:follows]-(:User { uuid : '#{uuid}'}) return following")
  end

  def followers_count(uuid)
     x = Neo4j::Session.query("match (follower:User)-[r:follows]->(:User { uuid : '#{uuid}'}), count(follower) as c return c")
     z=x.next
   end

  def followings_count(uuid)
     x = Neo4j::Session.query("match (following:User)<-[r:follows]-(:User { uuid : '#{uuid}'}), count(following) as c return c")
     z=x.next
  end

  def is_owner?(owner,object)
     unless owner.nil?
       x = Neo4j::Session.query("match (object:#{object.class.name.singularize} { uuid : '#{object.uuid}'})<-[owns:owns]-(owner:User { uuid : '#{owner.uuid}'}) return count(owner) as c")
puts x.next
       z=x.first[:c]
       z == 1
     else
       false
     end
   end

  def is_group_owner?(owner,object)
     unless owner.nil?
        x = Neo4j::Session.query("match (object:#{object.class.name.singularize} { uuid : '#{object.uuid}'})<-[owns:owns]-(owner:User { uuid : '#{owner.uuid}'}) return count(owner) as c")
puts x.next
        z=x.first[:c]
        z == 1
      else
        false
      end
   end


end
