class UserIdentities::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def developer
    set_auth 'developer'
  end

	def twitter
    set_auth 'twitter'
  end

	def facebook
    set_auth 'facebook'
  end

  def recursivePut a, i
      unless a.nil?
        i += 1
  	    puts "a#{i} ======================================================== #{a.class.name}"
	      if ["Hash","Array","Class"].include? a.class.name
	          puts a
	          a.each do |b|
	            puts (i+1).to_s + " ------" + b.to_s
	            recursivePut b, i
	         end
	      else
	          puts a
	      end
	    end
  end

	def set_auth provider

	  @user_identity = UserIdentity.from_omniauth(request.env["omniauth.auth"])

	  if @user_identity.persisted?
      sign_in_and_redirect @user_Identity, :event => :authentication #this will throw if @user_identity is not activated
      set_flash_message(:notice, :success, :kind => "#{provider}") if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

=begin
	  puts self.class.name
	  puts self.class

		auth_hash = request.env["omniauth.auth"]
	  puts "set_auth entered for provider #{provider} with:"
	  puts "info: #{auth_hash['info']}"
	  puts "extra: #{auth_hash['extra']}"
	  puts "current_identity: #{current_identity}"
	  puts "current_user: #{current_user}"
	  puts "credentials: #{auth_hash['credentials'].inspect}"
	  puts "user_identity: #{auth_hash}"


    recursivePut auth_hash['info'], 0
    recursivePut auth_hash['extra'], 0
    recursivePut auth_hash['credentials'], 0
   # auth_hash.each do |b|
  #    recursivePut(b, 0)
  #  end

    first_name = auth_hash['info']['first_name']
    last_name = auth_hash['info']['last_name']
    nickname = auth_hash['info']['nickname']
    name = auth_hash['info']['name']
		email = auth_hash['info']['email']
    uid = auth_hash['uid']
	  puts "uuid: #{uuid}"
	  # check existence of User-->UserIdentity-->Provider
		user_identity_provider = UserIdentity.find_full_identity(provider, email)

    if user_identity_provider && user_identity_provider[2] # identity and provider already exists
		    # create a session
		    puts "User already registered with '#{provider}'"
		    session.identity= user_identity_provider
		else
      if user_identity_provider && user_identity_provider[2].nil # provider does not exists for that email
		    puts "A user with the email '#{email}' already exists, but is not registered with '#{provider}'"
  			 if first_name == user_identity_provider[0].first_name and
  			    last_name == user_identity_provider[0].last_name and
  			    nickname == user_identity_provider[0].nick_name
    			    # user with the same email exists but with a different provider:
    			    # The new identity will be added

      		    puts "and have the same personal info, then the identity will be added to the user."
              user_identity_provider[1]. (
                provider = Provider.find_by(name:provider),
                token = auth_hash['credentials']['token'],
                secret = auth_hash['credentials']['secret'],
                url = "http://#{provider}.com/#{name}"
              )
              user_identity_provider[0].identity_providers << user_identity_provider[1]

      		    session.identity= user_identity_provider
      				redirect_to :new_identity_registration
      		else
      		    puts "but have different personal info, so cannot be registered'"
    			  # The user MUST login with an existing ientity and then 'add a new identity'
      				redirect_to :new_identity_registration,
      				  notice => "A user with the same email address but with a different profile already exists.\n" <<
      				            "Please, login with an existing ientity and then 'add a new identity'"
          end
      else # User doesn't exists
        puts "A user with this email '#{email}' doesn't exist, so it must be registered and a confirmation mail will be sent"

        user = User.create(first_name:first_name,last_name:last_name, nickname:nickname)
        if user
           prov = Provider.find_by(name:provider)
           user_identity = UserIdentity.find_by(uuid:uuid)
           user_identity.provider=prov
           user.identity_providers << user_identity

  		     session.identity= user_identity_provider
        else
    				redirect_to :new_identity_registration,
    				  notice => "An error creating a new identity occurred. Please, retry later.\n" <<
    				            "If the error persists please contact the technical support."
        end
      end
		end

		if user_identity
		  sign_in_and_redirect user_identity, :event => :authentication
		else
		  redirect_to :new_user_registration
		end
	end
=end
=begin
			current_identity
    	  puts "21: no current identity"
				unless current_identity = UserIdentity.find_full_identity(provider: provider, email: email)
      	  puts "31: useridentity not already registered"
      		name = auth_hash['info']['name']
      		first_name = auth_hash['info']['first_name']
      		last_name = auth_hash['info']['last_name']
      		nickname = auth_hash['info']['nickname']
      		nickname = first_name(1..1) + last_name(1..2) if nickname.nil?
					user_identity = UserIdentity.create({
						email: email,
						first_name: first_name,
						last_name: last_name,
            nickname: nickname,
						password: Devise.friendly_token[0,8]
					})
      	  puts "32: useridentity created #{user_identity}"
				end
			else
    	  puts "22: useridentity = current_identity"
				user_identity = current_identity
	  		session[user] = auth.user
		  	session[identity] = auth[identity]
			end

			unless auth = UserIdentity.find_by(provider: provider, email: email)
    	  puts "41: unless auth = UserIdentity.find_by(provider: provider, email: email)"
				auth = identity.build(provider: provider, email: email)
				identity.authorizations << auth
			end

			auth.update_attributes{(
    	  puts "51: update_attributes{("
				uuid= uuid,
				token= auth_hash['credentials']['token'],
				secret= auth_hash['credentials']['secret'],
				name= name,
				url= "http://#{provider}.com/#{name}"
			)}

			if user_identity
    	  puts "61: user_identity: sign_in_and_redirect identity, :event => :authentication"
				sign_in_and_redirect identity, :event => :authentication
			else
    	  puts "62: user_identity: redirect_to :new_identity_registration"
				redirect_to :new_identity_registration
			end
		end
=end


end
