require 'test_helper'

class PostCommentsControllerTest < ActionController::TestCase
  setup do
    @post_comment = post_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:post_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post_comment" do
    assert_difference('PostComment.count') do
      post :create, post_comment: {  }
    end

    assert_redirected_to post_comment_path(assigns(:post_comment))
  end

  test "should show post_comment" do
    get :show, id: @post_comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post_comment
    assert_response :success
  end

  test "should update post_comment" do
    patch :update, id: @post_comment, post_comment: {  }
    assert_redirected_to post_comment_path(assigns(:post_comment))
  end

  test "should destroy post_comment" do
    assert_difference('PostComment.count', -1) do
      delete :destroy, id: @post_comment
    end

    assert_redirected_to post_comments_path
  end
end
