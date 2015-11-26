require 'test_helper'

class CookielawsControllerTest < ActionController::TestCase
  setup do
    @cookielaw = cookielaws(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cookielaws)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cookielaw" do
    assert_difference('Cookielaw.count') do
      post :create, cookielaw: {  }
    end

    assert_redirected_to cookielaw_path(assigns(:cookielaw))
  end

  test "should show cookielaw" do
    get :show, id: @cookielaw
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cookielaw
    assert_response :success
  end

  test "should update cookielaw" do
    patch :update, id: @cookielaw, cookielaw: {  }
    assert_redirected_to cookielaw_path(assigns(:cookielaw))
  end

  test "should destroy cookielaw" do
    assert_difference('Cookielaw.count', -1) do
      delete :destroy, id: @cookielaw
    end

    assert_redirected_to cookielaws_path
  end
end
