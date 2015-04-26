module ApplicationHelper

  ALLOWED_DOMAIN_SERVER = ["joinple"]

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

  def calculate_full_path (sn)
    "http://#{sn.name.downcase.gsub(/\s+/, "")}.#{request.domain}"
  end

  def load_social_network_from_url
       puts "+++++++++++++++0 request.domain: #{request.domain}"
      sn = request.domain.split(".").first.downcase
       puts "+++++++++++++++0 sn: #{sn}"
      puts "ALLOWED_DOMAIN_SERVER.include? sn: #{ALLOWED_DOMAIN_SERVER.include? sn}"
      if ALLOWED_DOMAIN_SERVER.include? sn
        u = root_url.downcase
        sn = u[u.rindex("//")+2..-1].split(sn).first[0..-2]
      end 
       sn = sn.start_with?("test.") ? sn.split(".")[1] : sn 
       puts "+++++++++++++++1 sn: #{sn}"
       sn = sn.start_with?("dev.") ? sn.split(".")[1] : sn 
       puts "+++++++++++++++2 sn: #{sn}"
       sn = humanize_word(sn)
       puts "+++++++++++++++3 sn: #{sn}"
       csn = SocialNetwork.find_by( :iname => sn )
       csn = SocialNetwork.find_by( :name => sn ) if csn.nil?
       puts "+++++++++++++++4 csn.class.name: #{csn.class.name}"
       puts "+++++++++++++++5 csn: #{csn}"
       if csn.class.name == "SocialNetwork"
         set_current_social_network (csn)
         puts "current_social_network: #{current_social_network}"
         puts "caller: #{caller[0...5]}"
         current_social_network
       else
         raise "515","Current social network loading error"
       end
  end

  # admin services are reserved to admin users only
  def check_admin_user
    redirect_to(root_url, format: :js) unless current_user.admin?
  end

  # admin services are reserved to admin users only
  def current_user
    session.current_user
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
