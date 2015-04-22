module SessionsHelper
  include ApplicationHelper

  SUPER_SOCIAL_NETWORK_NAME = ["joinple"]
  SUPER_SOCIAL_BACKGROUND_COLOR = "#a12349"
  SUPER_SOCIAL_COLOR = "#ffffff"  #333342 white is a better solution

  def super_social_network_background_color
    SUPER_SOCIAL_BACKGROUND_COLOR
  end

  def super_social_network_color
    SUPER_SOCIAL_COLOR
  end

  def super_social_network_style
      "background-color: #{SUPER_SOCIAL_BACKGROUND_COLOR}; color: #{SUPER_SOCIAL_COLOR};"
  end

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
     set_current_user_profile
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
    if session[:social_network].class.name != "SocialNetwork"
      unless session[:social_network_uuid].nil?
        session[:social_network] = SocialNetwork.find(session[:social_network_uuid])
        puts "current_social_network loaded: name= #{current_social_network_name?}"
      else
        puts "TRAGEDY !!!!"
        raise "515", TRAGEDY
      end
    end
    session[:social_network]
  end

  def current_social_network_style
      "background-color: #{session[:social_network][:background_color]}; color: #{session[:social_network][:text_color]};"
  end

  def current_social_network_background_color?
      session[:social_network].background_color
  end

  def current_social_network_background_color_style
      "background-color: #{session[:social_network][:background_color]}"
  end

  def current_social_network_color?
      session[:social_network].text_color
  end

  def current_social_network_name?
     if session[:social_network].nil? 
        puts "session[:social_network][:name]   mancante!!!!!!!!!!!!!!"
        "aaa"
     else
        session[:social_network][:name]
     end
  end

  def current_social_network_uuid?
    current_social_network.uuid
  end

  def current_social_network_logo?
    #session[:social_network][:logo]
    current_social_network.logo
  end

  def current_group
    session[:group].nil? ? " " : session[:group]
  end

  def current_group_name?
    session[:group].nil? ? " " : session[:group].name
  end

  def current_group_uuid?
    session[:group].nil? ? " " : session[:group].uuid
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
    end
    @current_user
  end

  def current_user_id?
    session[:user_id]
  end

 def profile? user
    profile = user.profile?

    puts "user profile: #{profile}"
    #user_profile = Neo4j::Session.query("match (user:User { uuid : '#{user_id}' })-[has_profile:has_profile]->(profile:UserProfile) return profile").first[0]
    #puts "self.find_by_user after: #{user_profile.class.name} - #{user_profile}"
    profile
  end


  def set_current_user_profile
  #  session[:current_user_profile] = UserProfile.find_by_user session[:user_id]
  end

  # Return the current_user profile
  def current_user_profile
    session[:current_user_profile]
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
    session[:social_network] = nil
    session.delete[:current_user_profile] unless session[current_user_profile].nil?
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
    set_screen_geometry
    unless session[:social_network].class.name == "SocialNetwork" 
      puts "!!!!!!!!!!!!!!!!!! WARNING: I'M into check_social_network!!!"
       load_social_network_from_url
       puts "session[:social_network]: #{session[:social_network]}, class: #{session[:social_network].class.name}"
       if session[:social_network].nil? 
          redirect_to root_url
       end
    end

    puts "caller: #{caller[0...5]}"
    !session[:social_network].nil? 
  end

  def is_super_social_network?
    SUPER_SOCIAL_NETWORK_NAME.include? session[:social_network].name
  end

  def is_social_network_customer?
     is_customer = Neo4j::Session.query("match (u:User { uuid : '#{current_user.uuid}' })-[rel:is_customer]->(dest:SocialNetwork { uuid : '#{session[:social_network][:uuid]}' }) return rel")
     is_customer.count == 0 ? false : true
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

  def stars value
    res = Array.new
    #puts "value: #{value}"
    [1.0,2.0,3.0,4.0,5.0].each do |ind|
      if ind <= value #or ind == value
       # puts "#{ind} <= #{value}  ==> full"
        res << "full"
      elsif ind - 0.5 <= value
       # puts "#{ind - 0.5} <= #{value}  ==> half"
        res << "half"
      else
       # puts "#{ind} <=> #{value}  ==> empty"
        res << "empty"
      end
    end
    res 
  end

  def right_menu_icons_number 
    icon_number = Hash.new
    icon_number[:groups] = 4
    icon_number[:posts] = 4
    icon_number[:discussions] = 4
    icon_number[:pages] = 4
    icon_number[:media] = 4
    icon_number[:blogs] = 4
  end

  private

    def set_current_social_network (sn)
      puts "caller: #{caller[0...5]}"
      puts "HERE INTO set_current_social_network: #{sn} !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      if sn.nil?
        puts "sn is nil => faccio il logout"
        log_out
      else 
        session[:social_network_uuid] = sn.uuid
        session[:social_network] = sn

        puts "sn: #{current_social_network}"
        puts "sn.name: #{current_social_network.name}"
        reset_current_group
      end
    end



end
