module ApplicationHelper

  ALLOWED_DOMAIN_SERVER = ["ssdcafe","test","crowdupcafe"]

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

  def compute_social_name
      sn = request.domain.split(".").first.downcase
      if ALLOWED_DOMAIN_SERVER.include? sn
        u = root_url.downcase
        sn = u[u.rindex("//")+2..-1].split(sn).first[0..-2]
        puts "url split: #{sn}, root_url: #{u}"
      end 
       puts "sn pre #{sn}"
       sn = sn.start_with?("test.") ? sn.split(".")[1] : sn 
       sn = sn.start_with?("dev.") ? sn.split(".")[1] : sn 
       puts "sn post #{sn}"
      sn == "lavoro" ? "work" : sn
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
