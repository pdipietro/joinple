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
    puts "SN at home: #{sn.name} - sn.nil?: #{sn.nil?} "
    if sn.nil?
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
      false
    end
  end

  def privacy
  end

  def terms
  end



end
