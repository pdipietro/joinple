class SessionsController < ApplicationController
  before_action :check_social_network, only: [:new, :create]

  #render_to :js

  def new
    respond_to do |format|
        format.js
    end
  end

  def create
    puts "Params: #{params}"
    puts "Session: #{:email}"
    puts "AAAAAAAAAAAAAAAAAAARGGGGGHHH ________________________________"
    user = User.find_by(email: params[:session][:email])
    if user.nil? then
      user = User.find_by(nickname: params[:session][:email])
    end 

    if user && user.authenticate(params[:session][:password])
      if user.activated?
         log_in user
         params[:session][:remember_me] == '1' ? remember(user) : forget(user)
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

  def switch
     sn = params[:sn]         
     oldsn = current_social_name
     puts "Params: #{sn}, old: #{oldsn} *******************************************************************************************"
     unless sn == compute_social_name
       new_sn = SocialNetwork.find_by(:name => humanize_word(sn) )
       unless new_sn.nil?
         set_current_social_network(new_sn)
         redirect_to root_path        
       end
     end
  end

end
