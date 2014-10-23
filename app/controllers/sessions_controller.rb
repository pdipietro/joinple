class SessionsController < ApplicationController

  def create
    auth = auth_hash
    unless @auth = Identity.find_with_omniauth(auth)
        # Create a new user or add an auth to existing user, depending on
        # whether there is already a user signed in.
        @auth = Identity.create_with_omniauth(auth, current_identity)
      end
      # Log the authorizing user in.
      self.current_user = @auth.user
      self.current_identity = @auth.identity

      render :text => "Welcome, #{current_user.name}."
  end

  def identity= user_identity_provider
     puts "session#identity : "

  		user_identity_provider.each do |a|
  		  session[a.class.name][a]
  		end
  		puts "01: user: session[user]"
  		puts "01: identity: session[user_identity]"
  		puts "01: provider: session[provider]"
  end

  def destroy
     puts "session#destroy : "

    # Logout the User here

    puts "self session: #{self}"
    session.remove("user","user_identity","provider")
 #   session["user"].flush
#    session["user_identity"].flush
#    session["provider"].flush
    current_user = nil
    self.current_identity = nil
    puts "self session: terminated"
   end

  protected

    def uuauth_hash
      request.env['omniauth.auth']
    end

end