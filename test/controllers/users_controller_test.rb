require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = User.new(first_name: "John", last_name: "Doe", nickname: "jdo", email: "user@example.com",
              password: "password", password_confirmation: "password")
    @other_user = User.new(first_name: "Jane", last_name: "Doe", nickname: "janedo", email: "jane.doe@example.com",
              password: "password", password_confirmation: "password")
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {  }
    end

    assert_redirected_to user_path(assigns(:user))
  end

   test "should redirect edit when not logged in" do
    get :edit, uuid: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, uuid: @user, user: { first_name: @user.first_name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get :edit, uuid: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch :update, uuid: @user, user: { first_name: @user.first_name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

end
