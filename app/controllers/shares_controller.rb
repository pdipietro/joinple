class SharesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  respond_to :json

  def index
    render json: []
  end

  def create
    link = params[:url]

    share_params = {from_user_id: current_user.id}
    if to_user = User.find_by_name_or_email(params[:user])
      share_params[:to_user_id] = to_user.id
    else
      share_params[:to_email] = params[:user]
    end

    share = Share.create(share_params)
    render status: 200,
          json: {
            success: share.persisted?,
            share_id: share.id
          }
  end
end
