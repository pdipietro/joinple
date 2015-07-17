module ApplicationHelper

  ALLOWED_DOMAIN_SERVER = ["joinple","estatetuttoanno"]
  STAGE_HUMANIZED = { "dev" => "development", "development" => "development", "test" => "test", "demo" => "demo", "" => "production" }
  STAGE_BACKGROUND = { "dev" => "background-color : #5C8D69;", "development" => "background-color : #5C8D69;", "test" => "background-color : #fde8ee;", "demo" => "background-color : yellow;", "" => "" }


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

  def get_background
      STAGE_BACKGROUND[@stage]
  end

  def recode_env
    case ENV['RAILS_ENV']
      when "development" then "dev."
      when "dev"  then "dev."
      when "test" then "test."
      when "demo" then "demo."
      else ""
    end
  end

  def calculate_full_path (sn)
    #env = recode_env
    #"http://#{env}#{sn.name.downcase.gsub(/\s+/, "")}.#{request.domain}"
    "http://#{@stage}.#{sn.name.downcase.gsub(/\s+/, "")}.#{request.domain}"
  end

  def gethostname
    Socket.gethostname
  end

  def stage
    @stage
  end

  def stage_humanize
      STAGE_HUMANIZE[@stage]
  end

  def check_machine_name_vs_request
    host_name = gethostname

    sn = request.domain.split(".").first.downcase
    puts "ALLOWED_DOMAIN_SERVER.include? #{sn}: #{ALLOWED_DOMAIN_SERVER.include? sn}"
    if ALLOWED_DOMAIN_SERVER.include? sn
       u = root_url.downcase
       u = u[u.rindex("//")+2..-1]
       puts "root url: #{u}"
       stage = host_name.split("-") & u.split(".")
       puts "Stages: #{stage}"
       if stage.count == 1
          @stage = stage[0]
       else
         raise  "515","Error on redirected server: doesn't contains a stage fragment"
       end
    else
       raise  "516","Error: domain server #{sn} is not allowed"
    end
  end

  def load_social_network_from_url
      check_machine_name_vs_request
      sn = request.domain.split(".").first.downcase
      puts "ALLOWED_DOMAIN_SERVER.include? sn: #{ALLOWED_DOMAIN_SERVER.include? sn}"
      if ALLOWED_DOMAIN_SERVER.include? sn
        u = root_url.downcase
        sn = u[u.rindex("//")+2..-1].split(sn).first[0..-2]
      end 
       sn = sn.start_with?("test.") ? sn.split(".")[1] : sn 
       sn = sn.start_with?("dev.") ? sn.split(".")[1] : sn 
       sn = sn.start_with?("demo.") ? sn.split(".")[1] : sn 
       sn = humanize_word(sn)
       csn = SocialNetwork.find_by( :iname => sn.downcase )
       csn = SocialNetwork.find_by( :name => sn ) if csn.nil?
       if csn.class.name == "SocialNetwork"
         set_current_social_network (csn)
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

end
