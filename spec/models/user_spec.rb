require 'rails_helper'

RSpec.describe User, type: :model do
  let(:unit) { build :unit }
  let(:user) { build :user, unit: unit }
  let(:event) { build :event, unit: unit }
  let(:registration) { build :event_registration, user: user, event: event}

  it("should fill default attributes with default values") do 
    user = User.new()
    expect(user).not_to be_valid
    expect(user.membership_fee_bilance).to eq(0)
    expect(user.permission_level).to eq("biedrs")
  end
 
  it("should be valid with valid attributes") do
    expect(user).to be_valid
  end

  it("should be valid without nullable fields") do
    user.phone = nil
    user.email = nil
    user.birth_date = nil
    user.sex = nil
    expect(user).to be_valid
  end

  it("should be invalid without not nullable fields") do
    user.name = nil
    user.surname = nil
    user.activity_statuss = nil
    user.membership_fee_bilance = nil
    user.joined_date = nil
    user.permission_level = nil
    expect(user).not_to be_valid
  end

  it("should get users units information") do
    expect(user.unit).to eq(unit)
  end

  it("should get users registered events information") do
    event.save!
    registration.save!

    expect(user.events.first).to eq(event)
  end 
end
