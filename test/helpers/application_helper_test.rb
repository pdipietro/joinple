require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "a Generic Social Network"
    assert_equal full_title("Help"), "Help | a Generic Social Network"
    assert_equal full_title("Home"), "Home | a Generic Social Network"
    assert_equal full_title("Contact"), "Contact | a Generic Social Network"
  end
end