module SubjectsHelper

  # Returns the Gravatar for the given subject.
 # def gravatar_for(subject, options = { size: 80 }) 
 #   gravatar_id = Digest::MD5::hexdigest(subject.email.downcase)
 #   size = options[:size]
 #   gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
 #   #gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
 #   image_tag(gravatar_url, alt: subject.full_name, class: "gravatar img-responsive")
 # end

#  def full_name(subject)
#  def Subject.full_name
#    "#{subject.first_name} #{subject.last_name}"
#  end

  def Subject.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def Subject.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a subject in the database for use in persistent sessions.
  def remember
    self.remember_token = Subject.new_token
    update_attribute(:remember_digest, Subject.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def activated?
    true
  end

  def followers(uuid)
     Neo4j::Session.query("match (follower:Subject)-[r:follows]->(:Subject { uuid : '#{uuid}'}) return follower")
  end

  def followings(uuid)
     Neo4j::Session.query("match (following:Subject)<-[r:follows]-(:Subject { uuid : '#{uuid}'}) return following")
  end

  def followers_count(uuid)
     x = Neo4j::Session.query("match (follower:Subject)-[r:follows]->(:Subject { uuid : '#{uuid}'}), count(follower) as c return c")
     z=x.next
   end

  def followings_count(uuid)
     x = Neo4j::Session.query("match (following:Subject)<-[r:follows]-(:Subject { uuid : '#{uuid}'}), count(following) as c return c")
     z=x.next
  end

  def is_owner?(owner,object)
     unless owner.nil?
       x = Neo4j::Session.query("match (object:#{object.class.name.singularize} { uuid : '#{object.uuid}'})<-[owns:owns]-(owner:Subject { uuid : '#{owner.uuid}'}) return count(owner) as c")
puts x.next
       z=x.first[:c]
       z == 1
     else
       false
     end
   end

  def is_group_owner?(owner,object)
     unless owner.nil?
        x = Neo4j::Session.query("match (object:#{object.class.name.singularize} { uuid : '#{object.uuid}'})<-[owns:owns]-(owner:Subject { uuid : '#{owner.uuid}'}) return count(owner) as c")
puts x.next
        z=x.first[:c]
        z == 1
      else
        false
      end
   end

end
