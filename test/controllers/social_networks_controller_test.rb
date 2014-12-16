require 'test_helper'

class SocialNetworksControllerTest < ActionController::TestCase
  setup do
    @social_network = social_networks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:social_networks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create social_network" do
    assert_difference('SocialNetwork.count') do
      post :create, social_network: { description: @social_network.description, name: @social_network.name }
    end

    assert_redirected_to social_network_path(assigns(:social_network))
  end

  test "should show social_network" do
    get :show, id: @social_network
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @social_network
    assert_response :success
  end

  test "should update social_network" do
    patch :update, id: @social_network, social_network: { description: @social_network.description, name: @social_network.name }
    assert_redirected_to social_network_path(assigns(:social_network))
  end

  test "should destroy social_network" do
    assert_difference('SocialNetwork.count', -1) do
      delete :destroy, id: @social_network
    end

    assert_redirected_to social_networks_path
  end
end
