require 'rails_helper'

RSpec.describe Unit, type: :model do
  let(:unit) { build :unit }
  let(:user1) { build :user, unit: unit }
  let(:user2) { build :user, unit: unit }
  let(:payment) {build :membership_fee_payment, unit: unit, user_payed: user1, user_recorded: user2}
 
 
  it("should be valid with valid attributes") do
    expect(unit).to be_valid
  end

  it("should be valid without nullable fields") do
    unit.activity_location_name = nil
    unit.email = nil
    unit.phone = nil
    unit.comments = nil
    unit.deleted_at = nil
    unit.membership_fee = nil
    expect(unit).to be_valid
  end

  it("should be invalid without not nullable fields") do
    unit.city = nil
    unit.number = nil
    unit.legal_adress = nil
    unit.bank_account = nil
    expect(unit).not_to be_valid
  end

  it("should get units associated users") do
    unit.save!
    user1.save!
    user2.save!

    expect(unit.users.length).to eq(2)
    expect(unit.users[0]).to eq(user1)
    expect(unit.users[1]).to eq(user2)
  end

  it("should get the units membership fee payments") do
    unit.save!
    user1.save!
    user2.save!
    payment.save!

    expect(unit.membership_fee_payments.length).to eq(1)
    expect(unit.membership_fee_payments[0]).to eq(payment)
  end
end
