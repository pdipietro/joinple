class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session # was :exception

  after_filter  :set_csrf_cookie_for_ng

	def index
    render layout: layout_name
	end

	private

	  def set_csrf_cookie_for_ng
	    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
	  end

	  def verified_request?
	      super || form_authenticity_token == request.headers['HTTP_X_XSRF_TOKEN']
	  end

		def layout_name
				if params[:layout] == 0
				    false
				else
				    'application'
				end
		end

	protected

    helper_method :current_user, :signed_in?, :current_identity

    def current_user
      @current_user ||= User.find_by(uuid: session[:user_uuid])

    end

    def current_identity
      @current_identity ||= UserIdentity.find_by(uuid: session[:identity_uuid])
    end

    def signed_in?
      !!current_user
    end

    def current_user=(user)
      @current_user = user
      session[:user_uuid] = user.nil? ? nil : user.uuid
    end

    def current_identity=(identity)
      @current_identity = identity
      session[:identity_uuid] = identity.nil? ? nil : identity.uuid
    end
end
