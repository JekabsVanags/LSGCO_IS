class MembershipFeeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    users = User.all
    users.each do |user| #Katram sistēmas lietotājam izpilda darbu
      bilance_before = user.membership_fee_bilance #Lietotāja bilance pirms pārrēķina, lai var saglabāt izmaiņas.

      user.recalculate_bilance #Pārrēķinam lietotāja bilanci.

      if user.membership_fee_bilance < -30 #Ja cilvēks ir vairāk kā 30 eiro parādā, nosūta epastu. Reģistrē darbu cron_log.
        UserMailer.membership_fee_late_email(user).deliver_later

        CronLog.create({ description: "MembershipFeeJob; User: #{user.id}; Bilance_before: #{bilance_before}; Bilance_after: #{user.membership_fee_bilance}; Notification_email_sent: true" })
      else
        CronLog.create({ description: "MembershipFeeJob; User: #{user.id}; Bilance_before: #{bilance_before}; Bilance_after: #{user.membership_fee_bilance}" })
      end
    end
  end
end
