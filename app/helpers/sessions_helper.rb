module SessionsHelper
  include ApplicationHelper

 # get screen geometry from cookies
  def set_screen_geometry
     session[:width] = cookies[:width]
     session[:height] = cookies[:height]
     session[:pixelRatio] = cookies[:pixelRatio]
  end

 # Logs in the given user.
  def log_in(user)
     set_screen_geometry
     session[:user_id] = user.id
     session[:admin] = user.admin
     check_social_network
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Return the current Social Network
  def current_social_network
     session[:social_network]
  end

  def current_social_network_name?
     if session[:social_network].nil? 
        puts "session[:social_network][:name]   mancante!!!!!!!!!!!!!!"
        "aaa"
     else
        #puts "social_network #{session[:social_network][:name]} (#{session[:social_network].class})"
        session[:social_network][:name]
     end
  end

  def current_social_network_uuid?
    session[:social_network][:uuid]
  end

  def current_group
    session[:group]
  end

  def current_group_name?
    session[:group].nil? ? " " : session[:group][:name]
  end

  def current_group_uuid?
    session[:group].nil? ? " " : session[:group][:uuid]
  end

  def reset_current_group
    session[:group] = nil
  end

  def set_current_group(group)
    session[:group] = group
  end

  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find(user_id)
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
  # session[:social_network] = nil
    session.delete(:group) unless session[:group].nil?

    session.delete(:social_network) unless session[:social_network].nil?
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
    redirect_to(session[:forwarding_url] || default, format: :js)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  # check if the social network is changed
  def check_social_network
    puts "----------- get_screen_geometry in check social network "
    set_screen_geometry
    unless session[:social_network].class.name == "SocialNetwork" 
       load_social_network_from_url
       if session[:social_network].nil? 
          redirect_to root_url
       end
    end

    !session[:social_network].nil? 
  end

  def is_admin?
    !!session[:admin]
  end

  def is_group_admin?
    !!session[:current_group_admin]
  end

 # def current_group_uuid?
 #   puts "CurrentGroup: #{current_group}"
 #   current_group.nil? ? nil : current_group.uuid
 # end

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

  def count_relationships (obj)
#    rel = Neo4j::Session.query("match (user:User {uuid : '#{self.uuid}'})-[owns]->(x) return 'out' as dir, type(owns), labels(x),count(*) union match (user:User {uuid : '#{self.uuid}'})<-[owns]-(x) return 'in' as dir, type(owns), labels(x),count(*)")
    rel = Neo4j::Session.query("match (item:#{obj.class.name} {uuid : '#{obj.uuid}'})-[rel]->(x) return 'out' as dir, type(rel) as rel, labels(x) as label,count(*) as count union match (item:#{obj.class.name} {uuid : '#{obj.uuid}'})<-[rel]-(x) return 'in' as dir, type(rel) as rel, labels(x) as label, count(*) as count ")
    puts "rel: #{rel} - x2: #{rel.class.name} - x3: #{rel.count} "#- x4: #{x4} - x5: #{x5}, #{x5.class.name}"

    hash = Hash.new
    rel.each do |row|
      hash ["#{row[0]}-#{row[1]}-#{row[2][0]}"] = row[3]
    end

    puts "hash: #{hash}"
    hash
  end


  private

    def set_current_social_network (sn)
      puts "HERE INTO set_current_social_network !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      if sn.nil?
        puts "sn is nil => faccio il logout"
        log_out
      else 
        session[:social_network] = sn
        puts "sn: #{current_social_network}"
        puts "sn.name: #{current_social_network_name?}"
        reset_current_group
      end
    end

end
