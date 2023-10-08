require 'rails_helper'

RSpec.describe Unit, type: :model do
  let(:unit) { build :unit }
  let(:user1) { build :user, unit: unit }
  let(:user2) { build :user, unit: unit }
 
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
    expect(unit.users.first).to eq(user1)
    expect(unit.users.first).to eq(user2)
  end
end
