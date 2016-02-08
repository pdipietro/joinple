require 'test_helper'

class JdebugsControllerTest < ActionController::TestCase
  setup do
    @jdebug = jdebugs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jdebugs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create jdebug" do
    assert_difference('Jdebug.count') do
      post :create, jdebug: {  }
    end

    assert_redirected_to jdebug_path(assigns(:jdebug))
  end

  test "should show jdebug" do
    get :show, id: @jdebug
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @jdebug
    assert_response :success
  end

  test "should update jdebug" do
    patch :update, id: @jdebug, jdebug: {  }
    assert_redirected_to jdebug_path(assigns(:jdebug))
  end

  test "should destroy jdebug" do
    assert_difference('Jdebug.count', -1) do
      delete :destroy, id: @jdebug
    end

    assert_redirected_to jdebugs_path
  end
end
