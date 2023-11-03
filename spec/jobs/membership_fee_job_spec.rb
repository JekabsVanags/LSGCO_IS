require "rails_helper"

RSpec.describe MembershipFeeJob, type: :job do
  let(:unit) { create :unit, membership_fee: 1 }
  let(:unit2) { create :unit, membership_fee: 3 }

  let(:user) { create :user, unit: unit, membership_fee_bilance: 0 }
  let(:user1) { create :user, unit: unit, membership_fee_bilance: -30 }
  let(:user2) { create :user, unit: unit2, membership_fee_bilance: 0 }

  before(:each) do
    unit.save!
    unit2.save!
    user.save!
    user1.save!
    user2.save!

    ActiveJob::Base.queue_adapter = :test
  end

  it("should reduce users bilance by its units membership fee") do
    MembershipFeeJob.perform_now
    user.reload
    user1.reload
    user2.reload

    expect(user.membership_fee_bilance.to_i).to eq(-1)
    expect(user2.membership_fee_bilance.to_i).to eq(-3)
    expect(user1.membership_fee_bilance.to_i).to eq(-31)

    expect(CronLog.count).to eq(3)
  end

  it "should send email if users balance is below -30" do
    expect {
      MembershipFeeJob.perform_now
    }.to have_enqueued_job.on_queue("default")
  end
end
