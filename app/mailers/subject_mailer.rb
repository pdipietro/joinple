class SubjectMailer < ApplicationMailer
  default from: "registration@joinple.com"

  # Subject can be set in your I18n file at config/locales/en.yml  
  # with the following lookup:
  #
  #   en.subject_mailer.account_activation.subject
  #
  def account_activation(subject, url)
    @subject = subject
    @greeting = t("account_activation.mail_text.salutation") + " #{@subject.first_name},"
    @url = url

    mail to: @subject.email, subject: t("account_activation.subject")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subject_mailer.password_reset.subject
  #
  def password_reset(subject,url)
    @subject = subject
    @greeting = t("account_activation.mail_text.salutation") + " #{@subject.first_name},"
    @url = url

    mail to: @subject.email, subject: "Password reset"
  end
end
