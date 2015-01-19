require 'test_helper'

class PipposControllerTest < ActionController::TestCase
  setup do
    @pippo = pippos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pippos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pippo" do
    assert_difference('Pippo.count') do
      post :create, pippo: { pluto: @pippo.pluto }
    end

    assert_redirected_to pippo_path(assigns(:pippo))
  end

  test "should show pippo" do
    get :show, id: @pippo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pippo
    assert_response :success
  end

  test "should update pippo" do
    patch :update, id: @pippo, pippo: { pluto: @pippo.pluto }
    assert_redirected_to pippo_path(assigns(:pippo))
  end

  test "should destroy pippo" do
    assert_difference('Pippo.count', -1) do
      delete :destroy, id: @pippo
    end

    assert_redirected_to pippos_path
  end
end
