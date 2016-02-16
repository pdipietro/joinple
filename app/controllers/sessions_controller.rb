class SessionsController < ApplicationController
  before_action :check_social_network, only: [:new, :extnew] # :create]

  def admin
    respond_to do |format|
      format.html { render :newAdmin, object: :session }
    end
  end

  def extnew
    # debugger
    logger.debug 'session_controller: extnew'
    logger.debug "Social network has been checked: #{current_social_network_name?.downcase}"
    render 'extnew', layout: 'application'
  end


  def new
    # debugger
    logger.debug 'session_controller: new'
    logger.debug "Social network has been checked: #{current_social_network_name?.downcase}"
  end

  def create
    # debugger
    logger.debug "param= #{params[:session][:email]}"
    subject = Subject.find_by(email: params[:session][:email])
    logger.debug "Subject-by-email: #{subject}"
    if subject.nil?
      subject = Subject.find_by(nickname: params[:session][:email])
      logger.debug "Subject-email: #{subject}"
    end

    if subject && subject.authenticate(params[:session][:password])
      logger.debug 'Subject is authenticated'
      if subject.activated?
        log_in subject
        params[:session][:remember_me] == '1' ? remember(subject) : forget(subject)
        puts "ready to redirect_back_or subject: #{subject.full_name}, - #{subject.uuid}"
        redirect_back_or subject
      else
        message = 'Account not activated. '
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      respond_to do |format|
        format.html {render partial: 'new'}
        format.js {render 'new'}
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def tech_info

  end
end
