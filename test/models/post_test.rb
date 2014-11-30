require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
   @user = User.new(first_name: "John", last_name: "Doe", nickname: "jdo", email: "user@example.com",
            password: "password", password_confirmation: "password")
   # This code is not idiomatically correct.
    @post = Post.new(content: "Lorem ipsum", user_id: @user.uuid)
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "content should be present " do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal Micropost.first, microposts(:most_recent)
  end


end
