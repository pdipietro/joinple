class SessionsController < ApplicationController
  before_action :check_social_network, only: [:new] #, :create]

  #render_to :js

  def new
    puts "session_helper:new - Social network checked: it is #{current_social_network_name?.downcase}"
#    respond_to do |format|
#        format.js
#    end
  end

  def create
    puts "param= #{params[:session][:email]}"
    user = User.find_by(email: params[:session][:email])       
    puts "User-by-email: #{user}"
    if user.nil? then
      user = User.find_by(nickname: params[:session][:email])
    puts "User-email: #{user}"
    end 

    if user && user.authenticate(params[:session][:password])
      puts "User is authenticated"
      #puts "session_helper:create - Social network checked: it is #{current_social_network_name?}"
      if user.activated?
         log_in user
         params[:session][:remember_me] == '1' ? remember(user) : forget(user)
         puts "ready to redirect_back_or user: #{user.full_name}, - #{user.uuid}"
         redirect_back_or user
      else
         message  = "Account not activated. "
         message += "Check your email for the activation link."
         flash[:warning] = message
         redirect_to root_url
       end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def tech_info
    
  end

end
