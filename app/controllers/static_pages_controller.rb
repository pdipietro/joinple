class StaticPagesController < ApplicationController
  before_filter :check_social_network

  def about
  end

  def contacts
  end

  def help
  end

  def home
    sn = load_social_network_from_url
    puts "SN at home:#{sn} - sn.nil?: #{sn.nil?} "
    unless sn.nil?
      puts "CI DEVO PASSARE se sn.nil? = false"
      set_current_social_network (sn)   
      puts "FATTO: set_current_social_network (sn) da dentro def home"
    else
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
      false
    end
  end

  def privacy
  end

  def terms
  end



end
