class SessionsController < ApplicationController
  before_action :check_social_network, only: [:new, :create]

  #render_to :js

  layout "application"

  def new
    respond_to do |format|
        format.js
    end
  end

  def create
    puts "Params: #{params}"
    puts "Session: #{:email}"
    puts "create . 1"
    puts "session: #{session.id}, sn: #{current_social_network_name?}, user: #{current_user.nickname unless current_user.nil?}, admin: #{is_admin?} - group: #{current_group_name?} - group admin: #{is_group_admin?}"
    user = User.find_by(email: params[:session][:email])       
     puts " User.class: user.class"


    if user.nil? then
      user = User.find_by(nickname: params[:session][:email])
     puts " User.class-2: user.class"
    end 
puts " "
puts " - - - - - - - - - - - User && user.authenticate: #{user} - #{user.authenticate(params[:session][:password])}"
puts " "
    if user && user.authenticate(params[:session][:password])
      if user.activated?
         log_in user
         params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    puts "create . 2"
    puts "session: #{session.id}, sn: #{current_social_network_name?}, user: #{current_user.nickname unless current_user.nil?}, admin: #{is_admin?} - group: #{current_group_name?} - group admin: #{is_group_admin?}"
         redirect_back_or user
      else
         message  = "Account not activated. "
         message += "Check your email for the activation link."
     puts "create . 3"
    puts "session: #{session.id}, sn: #{current_social_network_name?}, user: #{current_user.nickname unless current_user.nil?}, admin: #{is_admin?} - group: #{current_group_name?} - group admin: #{is_group_admin?}"
         flash[:warning] = message
         redirect_to root_url
       end
    else
      flash.now[:danger] = 'Invalid email/password combination'
    puts "create . 4"
    puts "session: #{session.id}, sn: #{current_social_network_name?}, user: #{current_user.nickname unless current_user.nil?}, admin: #{is_admin?} - group: #{current_group_name?} - group admin: #{is_group_admin?}"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
