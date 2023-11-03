class MembershipFeeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    users = User.all
    users.each do |u|
      bilance_before = u.membership_fee_bilance
      u.recalculate_bilance
      if u.membership_fee_bilance < -30
        UserMailer.membership_fee_late_email(u).deliver_later
        CronLog.create({ description: "MembershipFeeJob; User: #{u.id}; Bilance_before: #{bilance_before}; Bilance_after: #{u.membership_fee_bilance}; Notification_email_sent: true" })
      else
        CronLog.create({ description: "MembershipFeeJob; User: #{u.id}; Bilance_before: #{bilance_before}; Bilance_after: #{u.membership_fee_bilance}" })
      end
    end
  end
end
