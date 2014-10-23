class UserIdentities::SessionsController < Devise::SessionsController
  respond_to  :json

  def show_current_identity
    reject_if_not_authorized_request!
    render status: 200,
      json: {
        success: true,
        info: "Current identity",
        identity: current_identity
      }
  end

  def failure
    render status: 401,
      json: {
        success: false,
        info: "Unauthorized",
        identity: current_identity
      }
  end

  private

    def reject_if_not_authorized_request!
      warden.authenticate!(
          scope: resource_name,
          recall: "#{controller_path}#failure")
    end

end