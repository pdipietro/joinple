class AccountActivationsController < ApplicationController

  def edit
    subject = Subject.find_by(email: params[:email])
    if subject && !subject.activated? && subject.authenticated?(:activation, params[:id])
      subject.activate
      log_in subject
      flash[:success] = "Account activated!"
      redirect_to subject
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

end
