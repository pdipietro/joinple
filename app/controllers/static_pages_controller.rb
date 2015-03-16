class StaticPagesController < ApplicationController
  before_filter :check_social_network
  layout "carousel", :only => [:carousel]
  
  def about
  end

  def contacts
  end

  def help
  end

  def home
    puts "Home-Logged in? : #{logged_in?}"
    if load_social_network_from_url.nil?
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
      false
    end

  end

  def privacy
  end

  def terms
  end

  def carousel
    puts "Carousel-Logged in? : #{logged_in?}"
    r='carousel'
    l="carousel"  
    if logged_in?
      r="home"
      l="application"
#    elsif current_social_network_name?.downcase == "gsn"
#      r='pre_carousel'
#      l="pre_carousel"  
    end
    render r, layout: l  

  end

end
