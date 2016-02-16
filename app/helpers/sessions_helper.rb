module SessionsHelper
  include ActionView::Helpers::DateHelper
  include ApplicationHelper
  include VersionHelper

  SUPER_SOCIAL_NETWORK_NAME = %w(joinple, estatetuttoanno).freeze
  SUPER_SOCIAL_BACKGROUND_COLOR = '#a02348'.freeze
  SUPER_SOCIAL_BACKGROUND_COLOR_REVERSE = '#323342'.freeze
  SUPER_SOCIAL_COLOR = '#ffffff'.freeze # was #333342 but white is a better solution

  SECONDARY_ITEMS_PER_PAGE = 24

  def set_accept_cookie
    cookies.permanent[:cookie_accepted] = true
  end

  def set_refuse_cookie
    cookies.permanent[:cookie_accepted] = false
  end

  def accepted_cookie?
    cookies[:cookie_accepted] == 'true' ? true : false
  end

  def accepted_cookie
    cookies[:cookie_accepted]
  end

  def accept_cookie?
    true  if cookies[:cookie_accepted] == true
    false if cookies[:cookie_accepted] == false
    nil   if cookies[:cookie_accepted].nil?
  end

  def super_social_network_background_color
    SUPER_SOCIAL_BACKGROUND_COLOR
  end

  def super_social_network_color
    SUPER_SOCIAL_COLOR
  end

  def super_social_network_style
    "background-color: #{SUPER_SOCIAL_BACKGROUND_COLOR}; color: #{SUPER_SOCIAL_COLOR};"
  end

  def super_social_network_style_reverse
    "background-color: #{SUPER_SOCIAL_BACKGROUND_COLOR_REVERSE}; color: #ffffff;"
  end

  def super_social_border_color
    "border-color: #{SUPER_SOCIAL_BACKGROUND_COLOR};"
  end

  # get screen geometry from cookies
  def set_screen_geometry
    session[:width] = cookies[:width]
    session[:height] = cookies[:height]
    session[:pixelRatio] = cookies[:pixelRatio].to_f
    session[:windowWidth] = cookies[:windowWidth]
    session[:windowHeight] = cookies[:windowHeight]
  end
=begin
  def cloudinary_name(name)
    session[:cloudinary_name] = name
  end

  def cloudinary_name?
    session[:cloudinary_name]
  end

  def cloudinary_clean(name)
    name[/v[0-9]*[^#]*/]
  end
=end
  def browser_geometry
    "cloudinary: #{cloudinary_name}, width: #{session[:width]}, height: #{session[:height]}, dpr: #{session[:pixelRatio]}, windowWidth: #{session[:windowWidth]}, windowHeight #{session[:windowHeight]} "
  end

  def browser_width
    session[:width]
  end

  def browser_height
    session[:height]
  end
  
  def window_width
    session[:windowWidth]
  end
  
  def window_height
    session[:windowHeight]
  end
  
  def window_pixelRatio
    browser_pixelRatio
  end

  def browser_pixelRatio
    session[:pixelRatio]
  end
 
  # Logs in the given subject.
  def log_in(subject)
    logger.debug '++++++++++++ Logging in ++++++++++++++++++++'
    set_screen_geometry
    session[:subject_id] = subject.id
    session[:admin] = subject.admin
    set_current_subject_profile
    # !!!!!!! check_social_network
  end

  # Remembers a subject in a persistent session.
  def remember(subject)
    subject.remember
    cookies.permanent.signed[:subject_id] = subject.id
    cookies.permanent[:remember_token] = subject.remember_token
  end

  # Return the current Social Network

  def current_social_network_style
    "background-color: #{current_social_network.social_network_color}; color: #{current_social_network.text_color};"
  end

  def current_social_network_social_network_color?
    current_social_network.social_network_color
  end

  def current_social_network_background_color?
    current_social_network.background_color
  end

  def current_social_network_background_color_style
    "background-color: #{current_social_network_background_color?}"
  end

  def current_social_network_text_color?
    current_social_network.text_color
  end

  def current_social_network_name?
      current_social_network.name
  end

  # Returns the owner of the current social network.

  def current_social_network_owner
    current_social_network.is_owned_by
  end

  def current_social_network_uuid?
    current_social_network.uuid
  end

  def current_social_network_logo?
    Image.new
  end

  def current_group
    @current_group = session[:group_uuid].nil? ? nil : Group.find(session[:group_uuid])
  end

  def reset_current_group
    # logger.debug '************************** RESET CURRENT GROUP ***********************************'
    # logger.debug caller[0..10]
    session[:group_uuid] = nil
    session[:group_admin] = nil
    # logger.debug '*************************END RESET CURRENT GROUP ***********************************'
  end

  def set_current_group(uuid)
    # logger.debug '*************************** SET CURRENT GROUP ************************************'
    # logger.debug caller[0..10]
    session[:group_uuid] = uuid
    x = Neo4j::Session.query("match(Subject { uuid : '#{current_subject_id?}' })-[r:owns|admins]->(g:Group { uuid : '#{uuid}' }) return count(g) as g")
    session[:group_admin] = (x.next[:g] > 0) ? true : false;
    # logger.debug '**************************END SET CURRENT GROUP ************************************''
  end

  def current_discussion
    @current_discussion = session[:discussion_uuid].nil? ? nil : Discussion.find(session[:discussion_uuid])
  end

  def reset_current_discussion
    session[:discussion_uuid] = nil
  end

  def set_current_discussion(uuid)
    session[:discussion_uuid] = uuid
  end

  # Returns the current logged-in subject (if any).
  def current_subject
    # debugger
    if (subject_id = session[:subject_id])
      @current_subject ||= Subject.find(subject_id)
    elsif (subject_id = cookies.permanent.signed[:subject_id])
      subject = Subject.find(subject_id)
      if subject && subject.authenticated?(:remember, cookies[:remember_token])
        log_in subject
        @current_subject = subject
      else
        @current_subject = nil
      end
    end
    @current_subject
  end

  def current_subject_id?
    session[:subject_id]
  end

  def profile?(subject)
    profile = subject.has_profile
    puts "subject profile: #{profile}"
    profile
  end

  def set_current_subject_profile
    session[:current_subject_profile] = current_subject.has_profile
  end

  # Return the current_subject profile
  def current_subject_profile?
    session[:current_subject_profile]
  end
 
  # Returns true if the subject is logged in, false otherwise.
  def logged_in?
    !current_subject.nil?
  end

  # Logs out the current subject.
  def log_out
    forget(current_subject)
    session.delete(:subject_id)
    session.delete(:admin)
    # session[:social_network] = nil
    session[:social_network_owner] = nil
    session[:cloudinary_name] = nil
    session[:current_subject_profile] = nil
    session[:current_social_network_uuid] = nil
    session.delete(:group) unless session[:group].nil?
    session.delete(:discussion) unless session[:discussion].nil?
    # session.delete(:social_network) unless session[:social_network].nil?
    @current_subject = nil
    @current_social_network = nil

    # session.reset
    # reset.cookies
  end

  # Forgets a persistent session.
  def forget(subject)
    rescue
      subject.forget
    ensure
      cookies.delete(:subject_id)
      cookies.delete(:remember_token)
  end

  # Returns true if the given subject is the current subject.
  def current_subject?(subject)
    subject == current_subject
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
    #debugger
    cs = current_social_network 
    redirect_to root_url if cs.nil?
    set_screen_geometry
    true
  end

  def is_super_social_network?
    logger.debug current_social_network_name?
    SUPER_SOCIAL_NETWORK_NAME.include? current_social_network_name?
  end

  def is_social_network_customer?
     is_customer = Neo4j::Session.query("match (u:Subject { uuid : '#{current_subject.uuid}' })-[rel:is_customer]->(dest:SocialNetwork { uuid : '#{current_social_network.uuid}' }) return rel")
     is_customer.count == 0 ? false : true
  end

  def is_admin?
    !!session[:admin]
  end

  def is_group_admin?
    !!session[:current_group_admin]
  end

  def is_my_profile?
    is_customer = Neo4j::Session.query("match (u:Subject { uuid : '#{current_subject.uuid}' })-[rel:has_profile]->(dest:SocialNetwork { uuid : '#{current_social_network.uuid}' }) return rel")
  end


 # def current_group_uuid?
 #   puts "CurrentGroup: #{current_group}"
 #   current_group.nil? ? nil : current_group.uuid
 # end

  def can_modify?(object)
    if is_admin?
      logger.debug "Can Modify? #{object.class.name.singularize}-#{object.uuid} because IS SYS ADMIN!!!"
      true
    elsif is_group_admin?
      logger.debug "Can Modify? #{object.class.name.singularize}-#{object.uuid} because IS GROUP ADMIN!!!"
      true
    elsif is_owner?(current_subject, object)
      logger.debug "Can Modify? #{object.class.name.singularize}-#{object.uuid} because IS OWNER!!!"
      true
    elsif is_group_owner?(current_group, object)
      logger.debug "Can Modify? #{object.class.name.singularize}-#{object.uuid} because IS GROUP OWNER!!!"
      true
    elsif is_subject_profile?(current_subject, object)
      logger.debug "Can Modify? #{object.class.name.singularize}-#{object.uuid} because IS HIS PROFILE!!!"
      true
    else
      false
    end
  end

  def count_relationships(obj)
    qs = "match (item:#{obj.class.name} {uuid : '#{obj.uuid}'})-[rel]->(x) return 'out' as dir, type(rel) as rel, labels(x) as label,count(*) as count      \
        union                                                                                                                                               \
          match (item:#{obj.class.name} {uuid : '#{obj.uuid}'})<-[rel]-(x) return 'in' as dir, type(rel) as rel, labels(x) as label, count(*) as count      \
        union                                                                                                                                               \
          match (item:#{obj.class.name} {uuid : '#{obj.uuid}'})-[rel]-(me:Subject {uuid : '#{current_subject_id?}'}) return 'in' as dir, type(rel) as rel, ['me'] as label, count(*) as count "

    rel = Neo4j::Session.query(qs)
    hash = {}
    rel.each do |row|
      hash ["#{row[0]}-#{row[1]}-#{row[2][0]}"] = row[3]
    end
    hash
  end

  def stars(value)
    res = []
    # logger.debug "value: #{value}"
    [1.0, 2.0, 3.0, 4.0, 5.0].each do |ind|
      if ind <= value # or ind == value
        # logger.debug "#{ind} <= #{value} ==> full"
        res << 'full'
      elsif ind - 0.5 <= value
        # puts "#{ind - 0.5} <= #{value} ==> half"
        res << 'half'
      else
        # puts "#{ind} <=> #{value} ==> empty"
        res << 'empty'
      end
    end
    res 
  end

  def right_menu_icons_number 
    icon_number = {}
    icon_number[:groups] = 4
    icon_number[:posts] = 4
    icon_number[:discussions] = 4
    icon_number[:pages] = 4
    icon_number[:media] = 4
    icon_number[:blogs] = 4
  end

  def set_checked parm,value
    (parm == value) ? %w(checked: 'checked') : %w(x: 1)
  end

  def secondary_items_per_page
    SECONDARY_ITEMS_PER_PAGE
  end

  def friendly_diff_date(time)
    delta = time - Time.now

    %w[years months days hours minutes seconds].collect do |step|
      seconds = 1.send(step)
      (delta / seconds).to_i.tap do
        delta %= seconds
      end
    end

    res =
      %w(years months days hours minutes seconds).each do |step|
        seconds = 1.send(step)
        (delta / seconds).to_i.tap do
          delta %= seconds
        end
      end

    logger.debug "friendly diff date of [#{time}] is: #{res}"
  end

  def caller_ip
    request.env['HTTP_X_FORWARDED_FOR']
  end

#  def build_post_image_path ()
#    path = "/subject/#{current_social_network_owner.uuid}/post"
#  end
  
#  def build_subject_image_path (user_profile, options = {} )
#    query = Neo4j::Session.query("match (o:SubjectProfile { uuid : '#{user_profile[:uuid]}' })<-[rel:has_profile]-(u:Subject) return u")
#    query.first[:u].uuid
#    path = "/subject/#{query.first[:u].uuid}"
#    options.each do |n,v|
#      path += "/#{n}/"
#      path += "#{v}" unless v.nil?
#    end
#    path
#  end

  def build_object_image_path(options = {})
    logger.debug "options: #{options}"
    path = ''
    path = options[:subject] ? '' : "/subject/#{current_social_network_owner.uuid}"
    options.each do |n, v|
      path += "/#{n}/"
      path += v.to_s unless v.nil?
    end
    path
  end

  def build_landing_image_path(options = {})
    path = "/landing/#{short_version}"
    options.each do |n, v|
      path += "/#{n}/"
      path += v.to_s unless v.nil?
    end
    path
  end

  def full_version
    session[:full_version]
  end

  def short_version
    session[:short_version]
  end

  def request_full_path
    request.original_url
  end

  def trace_call(caller, callee)
    # puts "*** TRACE - Method #{caller.split('/')[-2]} => #{callee}"
  end

  def trace_out
    # puts "*** ERRORE!!! - #{session[:social_network]}" unless session[:social_network].class.name == session[:old_session].class.name
  end

  def splatta(hash, title = '')
    if (hash.is_a?(::Hash) || hash.is_a?(::Array)) && hash != {}
      indent = 0
      logger.debug "------------------------ #{title} Hash splatting --------------------"
      case hash.is_a?(::Hash)
      when true
        hash.each do |p, v|
          if v.is_a?(::Hash)
            logger.debug "#{' ' * indent}#{p}:"
            indent += 4
            v.each do |p1, v1|
              logger.debug "#{' ' * indent}#{p1}: #{v1}"
            end
            indent -= 4
          end
        end
      when false
        hash.each do |v|
          if v.is_a?(::Hash)
            logger.debug "#{' ' * indent}#{p}:"
            indent += 4
            v.each do |p1, v1|
              logger.debug "#{' ' * indent}#{p1}: #{v1}"
            end
            indent -= 4
          end
        end
      end
    end
    logger.debug "-----------------------------------------------------------------------"
  end

  def splat(collection, title = '')
    if (collection.is_a?(::Hash) || collection.is_a?(::Array)) && collection != {}
      logger.info "------------------------ #{title} Collection splatting --------------------"
      splat1(collection, 0, '')
      logger.info '-----------------------------------------------------------------------'
    end
  end

  def splat1(item, indent, line)
    if item.is_a?(::Hash)
      item.each do |p, val|
        if val.is_a?(::Hash)
          splat1("#{p}:", indent, '')
          splat1(val, indent + 4, '')
        else
          logger.info "#{' ' * indent}#{p}: #{val}"
        end
      end
    elsif item.is_a?(::Array)
      item.each do |val|
        logger.info "#{' ' * indent}#{p}:"
        splat1(val, indent + 4, '')
      end
    else
      logger.info "#{' ' * indent}#{item}"
    end
  end

=begin      
      end
      indent = 0
      hash.each do |p, v|
        if v.is_a?(::Hash) || v.is_a?(::Array)
          logger.debug "#{' ' * indent}#{p}:"
          indent += 4
          v.each do |p1, v1|
            logger.debug "#{' ' * indent}#{p1}: #{v1}"
          end
          indent -= 4
        else
          logger.debug "#{' ' * indent}#{p}: #{v}"
        end
      end
      logger.debug "-----------------------------------------------------------------------"
  end
=end

  private

  def set_current_social_network(sn)
    logger.debug "HERE INTO set_current_social_network: #{sn.name} !!!"
    if sn.class.name == 'SocialNetwork'
      @current_social_network = sn
      session[:current_social_network_uuid] = sn.uuid
      session[:full_version] = VersionHelper::JOINPLE_VERSION
      session[:short_version] = VersionHelper::JOINPLE_VERSION[/v[0-9\.]*/]
      sn
    else
      logger.debug "sn class is #{sn.class.name} => logging out"
      log_out
      nil
    end
  end

  def current_social_network
    load_social_network_from_url if session[:current_social_network_uuid].nil?
    if @current_social_network.class.name != 'SocialNetwork' ||
       session[:current_social_network_uuid] != @current_social_network.uuid ||
       @current_social_network.nil?
      @current_social_network = SocialNetwork.find_by(uuid: session[:current_social_network_uuid])
    end
    @current_social_network 
  end
=begin
    if session[:social_network].class.name != 'SocialNetwork'
      logger.debug "PRE: session[:social_network]: #{session[:social_network]}"
      # debugger
      (
        logger.debug 'TRAGEDY !!!!'
        render(file: File.join(Rails.root, 'public/404'), formats: [:html], status: 404, layout: false)
      ) unless session[:social_network].uuid.nil?
      logger.debug "session[:social_network]: #{session[:social_network]}"
      if session[:social_network].class.name == 'cccccccccccccHash'
        session[:social_network] = session[:social_network]['social_network']
      else
        sn = SocialNetwork.find_by(uuid: session[:social_network].uuid)
        debugger if sn.class.name != 'SocialNetwork'
        session[:social_network] = sn
      end
      session[:old_session] = session[:social_network]
      logger.debug "current_social_network loaded: name= #{current_social_network_name?}"
    end
    session[:social_network]
=end

end


