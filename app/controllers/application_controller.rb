class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper :all
  #protect_from_forgery with: :exception
  include SessionsHelper
  include HttpAcceptLanguage::AutoLocale

  helper_method :load_social_network

  def caller_ip
    request.env['HTTP_X_FORWARDED_FOR']
  end

  private

    # Confirms a logged-in subject.
    def logged_in_subject
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url, format: :js, layout: 'application'
      end
    end

end
