class UserMailer < ApplicationMailer
  def first_login_email(creator, user, link)
    @creator = creator
    @user = user
    @link = link
    mail to: @user.email, subject: "Jūsu reģistrēšana LSGCO Informācijas Sistēmā", from: "lsgcois@skautiungaidas.lv"
  end

  def membership_fee_late_email(user)
    @user = user
    @last_payment = @user.payed_fees.last
    mail to: @user.email, subject: "Jums ir iekavējušies biedra naudas maksājumi", from: "lsgcois@skautiungaidas.lv"
  end
end
