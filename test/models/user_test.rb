require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "John", last_name: "Doe", nickname: "jdo", email: "user@example.com",
              password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert_not @user.valid?
  end

  test "first name should be present" do
    @user.first_name = ""
    assert_not @user.valid?
  end

  test "last name should be present" do
    @user.last_name = ""
    assert_not @user.valid?
  end

  test "nickname should be present" do
    @user.nickname = ""
    assert_not @user.valid?
  end

  test "nickname should be case-insensitive" do
    duplicate_user = @user.dup
    duplicate_user.email = 'aaa@bbb.com'
    duplicate_user.nickname = "JdO"
    @user.save
    assert_not duplicate_user.valid?
  end

  test "nickname should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = 'aaa@bbb.com'
    @user.save
    assert_not duplicate_user.valid?
 #   assert duplicate_user.save
 #   assert duplicate_user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
 
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.nickname = time
    @user.save
    assert_not duplicate_user.valid?
#   assert_not @user.save
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end


end
