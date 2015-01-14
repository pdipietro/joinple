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
     sn = params[:sn].downcase         
     oldsn = get_social_name
     puts "Params: #{sn}, old: #{oldsn} *******************************************************************************************"
     unless sn == compute_social_name
       session[:social_network_name] = sn
       base = ENV['RAILS_ENV']
       case base
          when "test"
            puts 'redirect_to "http://test.#{sn}.crowdupcafe.com"'
            redirect_to "http://test.#{sn}.crowdupcafe.com"
          when "development"
            puts 'redirect_to "http://dev.#{sn}.crowdupcafe.com"'
            redirect_to "http://dev.#{sn}.crowdupcafe.com"
          else
            puts 'redirect_to "http://#{sn}.crowdupcafe.com"'
            redirect_to "http://#{sn}.crowdupcafe.com"
       end
     end
  end
end
