class SharesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter: authenticate_user!

  respond_to :json

  def index
    render status: 200,
      json: {
        success: true,
        shares: crrent_users.shares
      }
  end

  def create
    share = Share.new(params[:share])
    if share.save
      render status: 200,
        json: {
          success: true,
          share: share.id
        }
    else
      render status: 200,
          json: {
            success: false,
            error: share.errors
          }
    end
  end
end
