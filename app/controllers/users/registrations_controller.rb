class Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }
  respond_to :json

  def registration # wasz create

    # create the user
    build_resource(sign_up_params)
    #try to save them
    if resource.save
      sign_in resource
      render status: 200,
      json: {
        success: true,
        info: "Registered",
        data: {
          user: resource,
          auth_token: current_user.authentication_token
        }
      }
    else
      #otherwise fail
      render status: :unprocessable_entity,
        json: {
          success: false,
          info: resource.errors,
          data: {}
        }
    end
  end
end
