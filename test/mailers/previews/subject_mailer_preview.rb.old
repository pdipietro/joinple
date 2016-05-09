# Preview all emails at http://localhost:3000/rails/mailers/subject_mailer
class SubjectMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subject_mailer/account_activation
  def account_activation
    subject = Subject.first
    subject.activation_token = Subject.new_token
    SubjectMailer.account_activation(subject)
  end

  # Preview this email at http://localhost:3000/rails/mailers/subject_mailer/password_reset
  def password_reset
    subject = Subject.first
    subject.reset_token = Subject.new_token
    SubjectMailer.password_reset(subject)
  end

end
