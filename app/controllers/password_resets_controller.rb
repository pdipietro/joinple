class PasswordResetsController < ApplicationController
  before_action :get_subject,   only: [:edit, :update]
  before_action :valid_subject, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @subject = Subject.find_by(email: params[:password_reset][:email].downcase)
    if @subject
      @subject.create_reset_digest
      @subject.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if both_passwords_blank?
      flash.now[:danger] = "Password/confirmation can't be blank"
      render 'edit'
    elsif @subject.update_attributes(subject_params)
      log_in @subject
      flash[:success] = "Password has been reset."
      redirect_to @subject
    else
      render 'edit'
    end
  end

  private

    def subject_params
      params.require(:subject).permit(:password, :password_confirmation)
    end

    # Returns true if password & confirmation are blank.
    def both_passwords_blank?
      params[:subject][:password].blank? &&
      params[:subject][:password_confirmation].blank?
    end

    # Before filters

    def get_subject
      @subject = Subject.find_by(email: params[:email])
    end

    # Confirms a valid subject.
    def valid_subject
      unless (@subject && @subject.activated? &&
              @subject.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @subject.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end

end