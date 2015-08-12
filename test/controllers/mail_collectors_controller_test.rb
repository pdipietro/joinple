require 'test_helper'

class MailCollectorsControllerTest < ActionController::TestCase
  setup do
    @mail_collector = mail_collectors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mail_collectors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mail_collector" do
    assert_difference('MailCollector.count') do
      post :create, mail_collector: { email: @mail_collector.email }
    end

    assert_redirected_to mail_collector_path(assigns(:mail_collector))
  end

  test "should show mail_collector" do
    get :show, id: @mail_collector
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mail_collector
    assert_response :success
  end

  test "should update mail_collector" do
    patch :update, id: @mail_collector, mail_collector: { email: @mail_collector.email }
    assert_redirected_to mail_collector_path(assigns(:mail_collector))
  end

  test "should destroy mail_collector" do
    assert_difference('MailCollector.count', -1) do
      delete :destroy, id: @mail_collector
    end

    assert_redirected_to mail_collectors_path
  end
end
