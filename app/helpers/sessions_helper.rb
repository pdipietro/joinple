module SessionsHelper
  include ApplicationHelper

 # Logs in the given user.
  def log_in(user)
     session[:user_id] = user.id
     session[:admin] = user.admin
     load_social_network_from_url
     puts "log_in(#{user.nickname}) in social network #{current_social_network_name?} done."
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Return the current Social Network
  def current_social_network
    @current_social_network
  end

  def current_group?
    @current_group
  end

  def current_group_name?
    @current_group.nil? ? "" : @current_group.name
  end

  def reset_current_group
    @current_group = nil
  end

  def set_current_group(group)
    @current_group = group
  end

  def current_social_network_name?
    @current_social_network.nil? ? "" : @current_social_network.name
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
#  puts "current_user-3: #{@current_user.id}"
   @current_user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    puts "Doing logout çççççççççççççççççççççççççççççççççççççççççççççççççççççççççççççççç"
    forget(current_user)
    session.delete(:user_id)
    session.delete(:admin)
  #  @current_social_network = nil
    @current_group = nil
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
    puts " ------------------------ redirect_back_or: (format: #{request.xhr?}) #{session[:forwarding_url] || default}"
    redirect_to(session[:forwarding_url] || default, format: :js)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  # check if the social network is changed
  def check_social_network
    puts "-------------- social network is #{!@current_social_network.nil? } - name: #{current_social_network_name?}"
    !@current_social_network.nil? 
  end

=begin
  # check if the social network is changed
  def check_social_network
    puts "check_social_network - logged_in? = #{logged_in?}"
    if logged_in?
      new_social_name = compute_social_name
      unless new_social_name = current_social_name
         set_current_social_network
         redirect_to root_path
      end
    end
    true
  end
=end

  def is_admin?
    !!session[:admin]
  end

  def is_group_admin?
    !!session[:current_group_admin]
  end

  def current_group_uuid?
    current_group.nil? ? nil : current_group.uuid
  end

  def can_modify?(object)
      if is_admin?
          puts "Can Modify? #{object.class.name.singularize}-#{object.uuid} because IS SYS ADMIN!!!"
          true
      elsif is_group_admin?
          puts "Can Modify? #{object.class.name.singularize}-#{object.uuid} because IS GROUP ADMIN!!!"
          true
      elsif is_owner?(current_user,object)
          puts "Can Modify? #{object.class.name.singularize}-#{object.uuid} because IS OWNER!!!"
          true
      elsif is_group_owner?(current_group,object)
          puts "Can Modify? #{object.class.name.singularize}-#{object.uuid} because IS GROUP OWNER!!!"
          true
      else
          false
      end
  end

  private

    def set_current_social_network (sn)
      if sn.nil?
        puts "sn is nil => faccio il logout"
        log_out
      else 
        @current_social_network = sn

        reset_current_group

        puts "CurrentSocialNetworkName: #{current_social_network_name?}"
        puts "CurrentGroup            : #{current_group_name?}"
      end
    end


end
