module ApplicationHelper
  ALLOWED_DOMAIN_SERVER = %w(joinple estatetuttoanno).freeze
  STAGE_HUMANIZED = {'dev' => 'development', 'test' => 'test', 'demo' => 'demo', 'deploy' => 'deploy'}.freeze
  STAGE_BACKGROUND = {'dev' => 'background-color : #5C8D69;', 'test' => 'background-color : #fde8ee;', 'demo' => 'background-color : yellow;', '' => ''}

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'a Generic Social Network'
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

  # Check the current stage.
  def dev?
    @normalized_stage == 'dev'
  end

  def test?
    @normalized_stage == 'test'
  end
  
  def demo?
    @normalized_stage == 'demo'
  end
  
  def deploy?
    @normalized_stage == 'deploy'
  end

  def background
    STAGE_BACKGROUND[@normalized_stage]
  end

  def stage_landing?
    @stage.ends_with? '_landing'
  end

  def application_full_path
    calculate_full_path 'www'
  end

  def calculate_full_path(sn)
    nm = sn.name.casecmp 'joinple' == 0 ? 'www' : sn.name.downcase.gsub(/\s+/, '')

    @stage == 'deploy' ? "http://#{nm}.#{request.domain}" : "http://#{@stage}.#{nm}.#{request.domain}"
  end

  def gethostname
    Socket.gethostname
  end

  def cloudinary_name?
    logger.debug "Cloudinary_name in application_helper: #{@cloudinary_name}"
    @cloudinary_name
  end

  def stage
    @stage
  end

  def humanized_stage
    @humanized
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
    logger.debug "Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = extract_locale_from_accept_language_header
    logger.debug "Locale set to '#{I18n.locale}'"
  end
 
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def normalized_stage
    @normalized_stage
  end

  def normalize_stage(stage)
    case
    when stage == 'deploy'
      'deploy'
    when stage.starts_with?('test')
      'test'
    when stage.starts_with?('demo')
      'demo'
    when stage.starts_with?('dev')
      'dev'
    end
  end

  def load_social_network_from_url
    set_locale
    check_machine_name_vs_request
    sn = request.domain.split('.').first.downcase
    logger.debug "ALLOWED_DOMAIN_SERVER.include? sn: #{ALLOWED_DOMAIN_SERVER.include? sn}"
    if ALLOWED_DOMAIN_SERVER.include? sn
      u = root_url.downcase
      sn = u[u.rindex('//') + 2..-1].split(sn).first[0..-2]
    end
    sn = sn.start_with?('test.') ? sn.split('.')[1] : sn
    sn = sn.start_with?('dev.')  ? sn.split('.')[1] : sn
    sn = sn.start_with?('demo.') ? sn.split('.')[1] : sn
    sn = humanize_word(sn)
    sn = 'joinple' if sn.casecmp 'www'
    csn = SocialNetwork.find_by iname: sn.downcase
    csn = SocialNetwork.find_by name: sn if csn.nil?
    # if no db is selected, default to www.joinple.com
    csn = SocialNetwork.find_by iname: 'www' if csn.nil?
    if csn.class.name == 'SocialNetwork'
      set_current_social_network csn
      current_social_network
    else
      logger.debug "Wromg social network class name: #{csn.class.name}"
      nil
    end
  end

  private

  def check_machine_name_vs_request
    host_name = gethostname
    logger.debug "host_name: #{host_name}"

    sn = request.domain.split('.').first.downcase
    logger.debug "social network requested: #{sn}"
    fail '516', "Error: domain server #{sn} is not allowed" unless ALLOWED_DOMAIN_SERVER.include? sn

    u = root_url.downcase
    stage = u[u.rindex('//') + 2..-1].split('.')
    # stage = u.split('.')
    @stage = stage.count > 3 ? stage[0] : 'deploy'

    @normalized_stage = normalize_stage @stage
    @humanized_stage = STAGE_HUMANIZED[@normalized_stage].to_s
    @cloudinary_name = "#{@normalized_stage}-joinple-com"
    logger.debug "social network '#{sn}' is allowed"
    logger.debug "requested stage: #{@stage}"
    logger.debug "normalized_stage: #{@normalized_stage}"
    logger.debug "humanized_stage: #{@humanized_stage}"
    logger.debug "cloudinary_name: #{@cloudinary_name}"
  end

end
