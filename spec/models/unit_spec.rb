require 'rails_helper'

RSpec.describe Unit, type: :model do
  let(:unit) { build :unit }
  let(:unit2) { build :unit }
  let(:user1) { build :user, unit: unit }
  let(:user2) { build :user, unit: unit }
  let(:event) { build :event, unit: unit }
  let(:event2) { build :event, unit: unit }
  let(:invite) { build :invite, event: event, unit: unit2, rank: "SK/G"}
  let(:invite2) { build :invite, event: event2, unit: unit2, rank: "SK/G"}
  let(:payment) {build :membership_fee_payment, unit: unit, user_payed: user1, user_recorded: user2}
  let(:position) {build :position, unit: unit, user: user1, position_name: "Nodarbību vadītājs"}
 
 
 
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

  it("should get units associated events") do
    event.save!
    expect(unit.events).not_to eq(nil)
  end

  it("should get units associated event invitatitons") do
    event.save!
    invite.save!
    expect(unit2.event_invites.first).to eq(event)
  end
  
  it("should get the units membership fee payments") do
    unit.save!
    user1.save!
    user2.save!
    payment.save!

    expect(unit.membership_fee_payments.length).to eq(1)
    expect(unit.membership_fee_payments[0]).to eq(payment)
  end

  it("should get the units positions") do
    unit.save!
    user1.save!
    position.save!

    expect(unit.positions.first).to eq(position)
  end


  it("should get units full name") do
    unit.save!

    expect(unit2.full_name).to eq("#{unit.city}s #{unit.number}. vienība")
  end

  it("should get upcoming events for a rank") do
    unit2.save!
    event.save!
    event2.save!
    invite.save!
    invite2.save!

    expect(unit2.get_actual_events("SK/G").length).to eq(2)
    expect(unit2.get_actual_events("SK/G")[0]).to eq(event)
    expect(unit2.get_actual_events("SK/G")[1]).to eq(event2)
    expect(unit2.get_actual_events("MZSK/GNT").length).to eq(0)
  end
end
