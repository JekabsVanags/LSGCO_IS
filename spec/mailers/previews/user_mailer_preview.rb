# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/first_login_email
  def first_login_email
    UserMailer.first_login_email(User.first, User.all[1], "/")
  end

end
