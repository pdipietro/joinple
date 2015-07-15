class SubjectMailer < ActionMailer::Base
  default from: "noreply@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subject_mailer.account_activation.subject
  #
  def account_activation(subject)
    @subject = subject
    @greeting = "Hi"

    mail to: subject.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subject_mailer.password_reset.subject
  #
  def password_reset(subject)
    @subject = subject
    @greeting = "Hi"

    mail to: subject.email, subject: "Password reset"
  end
end
