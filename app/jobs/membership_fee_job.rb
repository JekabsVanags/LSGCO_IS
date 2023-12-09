class MembershipFeeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    users = User.all
    users.each do |user|
      bilance_before = user.membership_fee_bilance
      user.recalculate_bilance
      if user.membership_fee_bilance < -30
        UserMailer.membership_fee_late_email(u).deliver_later
        CronLog.create({ description: "MembershipFeeJob; User: #{user.id}; Bilance_before: #{bilance_before}; Bilance_after: #{user.membership_fee_bilance}; Notification_email_sent: true" })
      else
        CronLog.create({ description: "MembershipFeeJob; User: #{user.id}; Bilance_before: #{bilance_before}; Bilance_after: #{user.membership_fee_bilance}" })
      end
    end
  end
end
