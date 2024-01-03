require "rails_helper"
include ActiveJob::TestHelper

RSpec.describe MembershipFeeJob, type: :job do
  let(:base_unit) { build :unit, number: 0, membership_fee: 2 }
  let(:unit) { create :unit, membership_fee: 1 }
  let(:unit2) { create :unit, membership_fee: 3 }

  let(:user) { create :user, unit: unit, membership_fee_bilance: 0, email: "email@email.com" }
  let(:user1) { create :user, unit: unit, membership_fee_bilance: -30, email: "email@email.com" }
  let(:user2) { create :user, unit: unit2, membership_fee_bilance: 0, email: "email@email.com" }
  let(:user3) { create :user, activity_statuss: "Daļēji aktīvs", unit: unit2, membership_fee_bilance: 0, email: "email@email.com" }

  before(:each) do
    unit.save!
    unit2.save!
    base_unit.save!
    user.save!
    user1.save!
    user2.save!
    user3.save!

    ActiveJob::Base.queue_adapter = :test
  end

  it("should reduce users bilance by its units membership fee, members that are only partially active only get reduced the base fee") do
    MembershipFeeJob.perform_now
    user.reload
    user1.reload
    user2.reload
    user3.reload
    base_unit.save!

    expect(user.membership_fee_bilance.to_i).to eq(-3)
    expect(user2.membership_fee_bilance.to_i).to eq(-5)
    expect(user1.membership_fee_bilance.to_i).to eq(-33)
    expect(user3.membership_fee_bilance.to_i).to eq(-2)

    expect(CronLog.count).to eq(4)
  end

  it "should send email if users balance is below -30" do
    MembershipFeeJob.perform_now
    expect(ActionMailer::Base.deliveries.size).to eq(1)
  end
end
