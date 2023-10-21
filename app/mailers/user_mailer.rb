class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.first_login_email.subject
  #
  def first_login_email(creator, user, link)
    @creator = creator
    @user = user
    @link = link
    mail to: @user.email, subject: "Jūsu reģistrēšana LSGCO Informācijas Sistēmā", from: "lsgcois@skautiungaidas.lv"

  end
end
