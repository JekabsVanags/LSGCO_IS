class UserMailer < ApplicationMailer
  #Pārveido informāciju, ar ko aizpilda epasta tekstu

  def first_login_email(creator, user, link)
    @creator = creator
    @user = user
    @link = link
    mail to: @user.email, subject: "Jūsu reģistrēšana LSGCO Informācijas Sistēmā", from: "lsgcois@skautiungaidas.lv"
  end

  def password_reset_email(user, link)
    @user = user
    @link = link
    mail to: @user.email, subject: "Paroles atjaunošana LSGCO Informācijas Sistēmā", from: "lsgcois@skautiungaidas.lv"
  end

  def membership_fee_late_email(user)
    @user = user
    @last_payment = @user.payed_fees.last
    mail to: @user.email, subject: "Jums ir iekavējušies biedra naudas maksājumi", from: "lsgcois@skautiungaidas.lv"
  end

  def user_resignation_email(user, leader, link)
    @user = user
    @leader = leader
    @link = link

    mail to: @leader.email, subject: "Biedrs #{user.name} #{user.surname} vēlas izstāties no organizācijas", from: "lsgcois@skautiungaidas.lv"
  end
end
