require 'test_helper'

class Users::UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  test "finds a user by username and returns true" do
    get :is_user, { name: @user.name }
    assert_equal JSON.parse(response.body)['success'], true
  end

  test "returns false for a user that does not exist" do
    get :is_user, { name: 'cleary_not_a_users_name' }
    assert_equal JSON.parse(response.body)['success'], false
  end

end
