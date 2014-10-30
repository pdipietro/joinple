class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def developer
    set_auth 'developer'
  end

       def twitter
    set_auth 'twitter'
  end

       def facebook
    set_auth 'facebook'
  end

  private

  def set_auth provider
    auth_hash = request.env["omniauth.auth"]

    uid = auth_hash['uid']
    name = auth_hash['info']['name']

    auth = Authorization.find_by(provider:provider, uid:uid)
    if auth
      user = auth.user
    else
      unless current_user
        unless user = User.find_by(name:name)
          user = User.create({
            name:name,
            password:Devise.friendly_token[0,8],
            email:"#{UUIDTools::UUID.random_create}@nil.com"
          })
        end
      else
        user = current_user
			end

      ## Finally, create an authorization for the current user
      unless auth = user.authorizations.find_by(provider:provider)
        auth = Authorization.create(provider:provider, uid:uid)
        user.authorizations << auth
      end

      auth.update_attributes({
        uid: uid,
        token: auth_hash['credentials']['token'],
        secret: auth_hash['credentials']['secret'],
        name: name,
        url: "http://#{provider}.com/#{name}"
      })

      if user
        sign_in_and_redirect user, :event => :authentication
      else
        redirect_to :new_user_registration
      end
	end
end
