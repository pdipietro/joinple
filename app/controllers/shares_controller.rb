class SharesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  respond_to :json

  def index
    render :json []
  end

  def create
    link = params[:url]

    share_params = {from_user_id: current_user.id}
    if to_user = UserIdentity.find_by_email(params[:user_identity])
      share_params[:to_user_id] = to_user.id
    else
      share_params[:to_email] = params[:user]
    end

    share = Share.create(share_params)
    render status: 200,
      json: {
        succes: share.persisted?,
        share_id: share.id
      }
  end
end
