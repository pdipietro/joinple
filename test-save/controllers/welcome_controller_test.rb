require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
    setup do
      @user = users(:one)
    end

    test "should render the index view without a user" do
      get :index
      assert_template :index
      assert_template layout: "layouts/noauth"
      assert_response :success
    end

    test "should render the dashboard view with the auth template" do
      sign_in @user
      get :dashboard
      assert_template :dashboard
      assert_template layout: "layouts/auth"
    end

   test "should redirect from dashboard view to index without a user" do
      get :dashboard
      assert_response :redirect
    end

end