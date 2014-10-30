require 'test_helper'

class Users::SessionsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  test "the user receives a 401 if not logged in at /current_user" do
    get :show_current_user
    assert_response 401
  end
  test "the user receives success user data if signed in" do
    sign_in @user
    get :show_current_user
    assert_response :success
  end
end
