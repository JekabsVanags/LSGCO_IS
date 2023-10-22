require 'rails_helper'

RSpec.describe MembershipFeePayment, type: :model do
  let(:unit) { build :unit }
  let(:user1) { build :user, unit: }
  let(:user2) { build :user, unit: }
  let(:payment) { build :membership_fee_payment, unit:, user_payed: user1, user_recorded: user2 }

  it('should create membership fee payment') do
    payment = MembershipFeePayment.new(unit:, user_payed: user1, user_recorded: user2, amount: 20,
                                       date: Date.today)
  end

  it('should not validate payment with wrong data') do
    payment.amount = nil
    payment.date = nil
    expect(payment).not_to be_valid
  end
end
