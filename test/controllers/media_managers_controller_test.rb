require 'test_helper'

class MediaManagersControllerTest < ActionController::TestCase
  setup do
    @media_manager = media_managers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_managers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_manager" do
    assert_difference('MediaManager.count') do
      post :create, media_manager: {  }
    end

    assert_redirected_to media_manager_path(assigns(:media_manager))
  end

  test "should show media_manager" do
    get :show, id: @media_manager
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @media_manager
    assert_response :success
  end

  test "should update media_manager" do
    patch :update, id: @media_manager, media_manager: {  }
    assert_redirected_to media_manager_path(assigns(:media_manager))
  end

  test "should destroy media_manager" do
    assert_difference('MediaManager.count', -1) do
      delete :destroy, id: @media_manager
    end

    assert_redirected_to media_managers_path
  end
end
