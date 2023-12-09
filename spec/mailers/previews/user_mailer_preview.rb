# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def first_login_email
    UserMailer.first_login_email(User.first, User.first, "/")
  end

  def password_reset_email
    UserMailer.password_reset_email(User.first, "/")
  end

  def membership_fee_late_email
    UserMailer.membership_fee_late_email(User.first)
  end

  def user_resignation_email
    UserMailer.user_resignation_email(User.first, User.first, "/")
  end
end
