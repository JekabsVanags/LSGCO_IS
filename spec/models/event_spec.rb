require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:unit) { build :unit }
  let(:unit2) { build :unit }
  let(:user) { build :user, unit: }
  let(:event) { build :event, unit: }
  let(:invite) { build :invite, unit: unit2, event: }
  let(:reg) { build :event_registration, event:, user: }

  it('should be valid without nullable fields') do
    event.description = nil
    event.date_to = nil
    event.necessary_volunteers = nil
    event.max_participants = nil
    event.deleted_at = nil
    expect(event).to be_valid
  end

  it('should be invalid without not nullable fields') do
    event.name = nil
    event.date_from = nil
    event.event_type = nil
    expect(event).not_to be_valid
  end

  it('should fill in default values') do
    event = Event.new

    expect(event.registered_participants).to eq(0)
    expect(event.registered_volunteers).to eq(0)
  end

  it('should get events invited units') do
    unit.save!
    invite.save!

    expect(event.invited_units.first).to eq(unit2)
  end

  it('should get events registered users') do
    user.save!
    reg.save!

    expect(event.users.first).to eq(user)
  end
end
