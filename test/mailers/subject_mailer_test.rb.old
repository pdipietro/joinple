require 'test_helper'

class SubjectMailerTest < ActionMailer::TestCase

  def setup
    @subject = Subject.new(first_name: "John", last_name: "Doe", nickname: "jdo", email: "subject@example.com",
              password: "password", password_confirmation: "password")
  end

  test "account_activation" do
    subject = @subject
    subject.activation_token = Subject.new_token
    mail = SubjectMailer.account_activation(subject)
    assert_equal "Account activation", mail.subject
    assert_equal [subject.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match subject.first_name,         mail.body.encoded
    assert_match subject.activation_token,   mail.body.encoded
    assert_match CGI::escape(subject.email), mail.body.encoded
    end

  test "password_reset" do
    subject = @subject
    subject.reset_token = Subject.new_token
    mail = SubjectMailer.password_reset
    assert_equal "Password reset", mail.subject
    assert_equal [subject.email], mail.to
    assert_equal ["to@example.org"], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match subject.first_name,         mail.body.encoded
    assert_match subject.reset_token,        mail.body.encoded
    assert_match CGI::escape(subject.email), mail.body.encoded
  end

end
