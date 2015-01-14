module SessionsHelper
  include ApplicationHelper

 # Logs in the given user.
  def log_in(user)
     session[:social_network_name] = compute_social_name
     session[:user_id] = user.id
     session[:admin] = user.admin
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find(user_id)
      puts "current_user-1: #{@current_user.id}"
    elsif (user_id = cookies.permanent.signed[:user_id])
      user = User.find(user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      else
        @current_user = nil
      end
      puts "current_user-2: #{@current_user.id}"
    end
   @current_user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    session.delete(:admin)
    @current_user = nil
  end

  # Forgets a persistent session.
  def forget(user)
    begin
      rescue
        user.forget
      ensure
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end
  
   # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    puts " ---------------------------------------------------------- redirect_back_or: (format: #{request.xhr?}) #{session[:forwarding_url] || default}"
    redirect_to(session[:forwarding_url] || default, format: :js)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  # Stores the latest URL requested
#  def store_latest_url
#    session[:latest_url] = request.url # if request.get?
#    puts "session[:latest_url]: #{session[:latest_url]} @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
#  end

  # Redirect to latest url
#  def redirect_back
#    redirect_to session[:latest_url]
#  end

  # check if the social network is changed
  def check_social_network
    puts "check_social_network - logged_in? = #{logged_in?}"
    if logged_in?
      actual = compute_social_name
      if session[:social_network_name] != actual
          log_out 
          flash[:warning] = "Please, you need to login when changing social network."
          redirect_to login_path
      end
      true
    end
=begin
    puts "check_social_network 22222222 - logged_in? = #{logged_in?}"
    if logged_in? && session[:social_network_name] = compute_social_name
       true
    else
       log_out 
       flash[:warning] = "Please, you need to login when changing social network."
       redirect_to login_path
    end
=end
  end

  def get_social_name
    sn = session[:social_network_name]
    sn = compute_social_name if sn.nil?
    sn
  end

  def is_admin?
    !!session[:admin]
  end

end
