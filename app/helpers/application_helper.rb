module ApplicationHelper

  ALLOWED_DOMAIN_SERVER = ["joinple","estatetuttoanno"]
  STAGE_HUMANIZED = { "dev" => "development", "test" => "test", "demo" => "demo", "deploy" => "deployment" }
  STAGE_BACKGROUND = { "dev" => "background-color : #5C8D69;", "test" => "background-color : #fde8ee;", "demo" => "background-color : yellow;", "" => "" }

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "a Generic Social Network"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # Returns a random token.
  def new_token
    SecureRandom.urlsafe_base64
  end

  # normalize stage
  def normalize_stage (stage)
    "deploy"  if stage == "" 
    "test"        if stage.starts_with?("test")
    "demo"        if stage.starts_with?("demo")
    "dev"         if stage.starts_with?("dev")
  end

  # Check the current stage.
  def is_dev? 
    @normalize_stage == "dev"
  end

  def is_test?
    @normalize_stage == "test"
  end
  
  def is_demo?
    @normalize_stage == "demo"
  end
  
  def is_deploy?
    @normalize_stage == "deploy"
  end

  def get_background
      STAGE_BACKGROUND[@normalized_stage]
  end

  def stage_landing?
      @stage.ends_with? "_landing"
  end


  def application_full_path
    if @stage == "deploy"
      "http://www.#{request.domain}"
    else
      "http://#{@stage}.www.#{request.domain}"
    end
  end

  def calculate_full_path (sn)
    nm = sn.name.casecmp("joinple") == 0 ? "www" : sn.name.downcase.gsub(/\s+/, "")
    if @stage == "deploy"
      fp = "http://#{nm}.#{request.domain}"
    else
      fp = "http://#{@stage}.#{nm}.#{request.domain}"
    end

    fp
  end

  def gethostname
    Socket.gethostname
  end

  def stage
    @stage
  end

  def humanized_stage
    "#{STAGE_HUMANIZED[@normalized_stage]}"
  end

  def cloudinary_name?
    logger.debug "Cloudinary_name in application_helper: #{@cloudinary_name}"
    @cloudinary_name
  end

  def check_machine_name_vs_request
    host_name = gethostname

    logger.debug ("host_name: #{host_name}")

    sn = request.domain.split(".").first.downcase
    logger.debug ("sn: #{sn}")

    logger.debug "ALLOWED_DOMAIN_SERVER.include? #{sn}: #{ALLOWED_DOMAIN_SERVER.include? sn}"
    if ALLOWED_DOMAIN_SERVER.include? sn
       u = root_url.downcase
       u = u[u.rindex("//")+2..-1]
       stage = u.split(".")
       if stage.count > 3
          @stage = stage[0]
          @normalized_stage = normalize_stage (@stage)
          cloudinary_name "#{@normalized_stage}-joinple-com"
       else
          @stage = ""
          @normalized_stage = normalize_stage (@stage)
          cloudinary_name "#{humanized_stage}-joinple-com"
       end
    else
       raise  "516","Error: domain server #{sn} is not allowed"
    end
    logger.debug ("status: stage: #{@stage} - normalized_stage: #{@normalized_stage} - humanized_stage: #{humanized_stage} - Cloudinary_name: #{cloudinary_name?}")

  end

  def load_social_network_from_url

      set_locale

      check_machine_name_vs_request
      sn = request.domain.split(".").first.downcase
      logger.debug "ALLOWED_DOMAIN_SERVER.include? sn: #{ALLOWED_DOMAIN_SERVER.include? sn}"
      if ALLOWED_DOMAIN_SERVER.include? sn
        u = root_url.downcase
        sn = u[u.rindex("//")+2..-1].split(sn).first[0..-2]
      end 
       sn = sn.start_with?("test.") ? sn.split(".")[1] : sn 
       sn = sn.start_with?("dev.")  ? sn.split(".")[1] : sn 
       sn = sn.start_with?("demo.") ? sn.split(".")[1] : sn 
       sn = humanize_word(sn)
       sn = "joinple" if sn.downcase == "www" 
       csn = SocialNetwork.find_by( :iname => sn.downcase )
       csn = SocialNetwork.find_by( :name => sn ) if csn.nil?
       csn = SocialNetwork.find_by( :iname => "www" ) if csn.nil?    # if no db is selected, default to www.joinple.com
       logger.debug ("SocialNetwork: #{csn.class.name}")
       if csn.class.name == "SocialNetwork"
         set_current_social_network (csn)
         logger.debug "current_social_network,class: #{current_social_network.class}"
         current_social_network
       else
         raise "515","Current social network loading error"
       end
  end

  # admin services are reserved to admin subjects only
  def check_admin_subject
    redirect_to(root_url, format: :js) unless current_subject.admin?
  end

  # admin services are reserved to admin subjects only
  def current_subject
    session.current_subject
  end

  # capitalize the first word and any first word after a '.' 
  def humanize_word(name)
      name.split('.').map(&:strip).map(&:capitalize).join('. ')
  end

  # capitalize the first word and any first word after a '.' and add a final '.'
  def humanize_sentence(sentence)
      sentence.split('.').map(&:strip).map(&:capitalize).join('. ') + '.'
  end

  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = extract_locale_from_accept_language_header
    logger.debug "* Locale set to '#{I18n.locale}'"
  end
 
  private
  
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

end
