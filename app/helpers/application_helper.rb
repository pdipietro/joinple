module ApplicationHelper

  ALLOWED_DOMAIN_SERVER = ["joinple","estatetuttoanno"]
  STAGE_HUMANIZED = { "dev" => "development", "dev5" => "development", "test" => "test", "demo" => "demo", "" => "production" }
  STAGE_BACKGROUND = { "dev" => "background-color : #5C8D69;", "dev5" => "background-color : #5C8D69;", "test" => "background-color : #fde8ee;", "demo" => "background-color : yellow;", "" => "" }
  ALLOWED_STAGES = { "dev" => "dev", "dev5" => "dev", "test" => "test", "demo" => "demo", "production" => "" }


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

  # Check the current stage.
  def is_dev 
    ["dev","dev5"].include? @stage
  end
  def is_test
    @stage == "test"
  end
  def is_demo
    @stage == "demo"
  end
  def is_deploy
    @stage == ""
  end

  def get_background
      STAGE_BACKGROUND[@stage]
  end

  def calculate_full_path (sn)
    nm = sn.name.casecmp("joinple") == 0 ? "www" : sn.name.downcase.gsub(/\s+/, "")
    if @stage == ""
      "http://#{nm}.#{request.domain}"
    else
      "http://#{@stage}.#{nm}.#{request.domain}"
    end
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

  def cloudinary_name?
      puts "Cloudinary_name in application_helper: #{@cloudinary_name}"
      @cloudinary_name
  end

  def check_machine_name_vs_request
    host_name = gethostname

    puts ("host_name: #{host_name}")

    sn = request.domain.split(".").first.downcase
    puts ("sn: #{sn}")

    puts "ALLOWED_DOMAIN_SERVER.include? #{sn}: #{ALLOWED_DOMAIN_SERVER.include? sn}"
    if ALLOWED_DOMAIN_SERVER.include? sn
       u = root_url.downcase
       u = u[u.rindex("//")+2..-1]
       puts "root url: #{u} - #{host_name.split("-")}"
       stage = host_name.split("-") & u.split(".")
       puts "Stages: #{stage}"
       if stage.count == 1
          @stage = stage[0]
          @cloudinary_name = "#{ALLOWED_STAGES[@stage]}-joinple-com"
          cloudinary_name("#{ALLOWED_STAGES[@stage]}-joinple-com")
       else
         @stage = ""
         @cloudinary_name = ""
         #raise  "515","Error on redirected server: doesn't contains a stage fragment"
       end
    else
       raise  "516","Error: domain server #{sn} is not allowed"
    end
    puts ("@stage: #{@stage}")
    puts "Cloudinary_name creation: #{@cloudinary_name}"

  end

  def load_social_network_from_url

      set_locale

      check_machine_name_vs_request
      sn = request.domain.split(".").first.downcase
      puts "ALLOWED_DOMAIN_SERVER.include? sn: #{ALLOWED_DOMAIN_SERVER.include? sn}"
      if ALLOWED_DOMAIN_SERVER.include? sn
        u = root_url.downcase
        sn = u[u.rindex("//")+2..-1].split(sn).first[0..-2]
      end 
       sn = sn.start_with?("test.") ? sn.split(".")[1] : sn 
       sn = sn.start_with?("dev.")  ? sn.split(".")[1] : sn 
       sn = sn.start_with?("dev5.") ? sn.split(".")[1] : sn 
       sn = sn.start_with?("demo.") ? sn.split(".")[1] : sn 
       sn = humanize_word(sn)
       sn = "joinple" if sn.downcase == "www" 
       csn = SocialNetwork.find_by( :iname => sn.downcase )
       csn = SocialNetwork.find_by( :name => sn ) if csn.nil?
       csn = SocialNetwork.find_by( :iname => "www" ) if csn.nil?    # if no db is selected, default to www.joinple.com
       if csn.class.name == "SocialNetwork"
         set_current_social_network (csn)
         puts "current_social_network,class: #{current_social_network.class}"
         current_social_network
       else
         raise "515","Current social network loading error"
       end
  end

#BEGIN
  def SSSremap_sn_owner (sn)
        puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SOCIAL NETWORK VERIFY OWNER <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" 
        begin
          sn.is_owned_by
          puts "is_owned_by doesn't fail" 
        rescue
          puts "is_owned_by failed: rescue started" 
          query = Neo4j::Session.query("match (o:SocialNetwork} { uuid : '#{sn[:uuid]}' })<-[rel:owns]-(u:Subject) delete rel return u")
          subject = query.first[:u] 
          puts "owner: #{subject}"
          rel = Owns.create(from_node: subject, to_node: sn) 
          puts "sn.isownedby: #{sn.is_owned_by}"
        end  
        csn = SocialNetwork.find( sn.uuid )
  end
#END


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
