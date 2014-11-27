require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.new( first_name: "John", last_name: "Doe", nickname: "jdo", email: "user@example.com",
              password: "password", password_confirmation: "password")
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { first_name:  "",
                                    last_name: "",
                                    nickname: "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end

   test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    first_name  = "Foo"
    last_name = "Bar"
    nickname = "fob"
    email = "foo@bar.com"
    patch user_path(@user), user: { first_name:  first_name,
                                    last_name: last_name,
                                    nick_name: nick_name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.first_name,  first_name
    assert_equal @user.last_name,  last_name
    assert_equal @user.nickname,  nickname
    assert_equal @user.email, email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    first_name  = "Foo"
    last_name = "Bar"
    nickname = "fob"
    email = "foo@bar.com"
    patch user_path(@user), user: { first_name:  first_name,
                                    last_name: last_name,
                                    nick_name: nick_name,
                                    email: email,
                                    password:              "foobar",
                                    password_confirmation: "foobar" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.first_name,  first_name
    assert_equal @user.last_name,  last_name
    assert_equal @user.nickname,  nickname
    assert_equal @user.email, email
  end

end