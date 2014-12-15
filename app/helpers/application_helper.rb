module ApplicationHelper

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
      sn = request.domain.split(".").first
      if (sn == "ssdcafe")
        u = root_url
        sn = u[u.rindex("//")+2..-1].split("ssdcafe").first[0..-2]
        puts "url split: #{sn}"
      end 
      sn == "lavoro" ? "work" : sn
  end

end
