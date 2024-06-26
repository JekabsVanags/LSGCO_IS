require 'rails_helper'

RSpec.describe User, type: :model do
  let(:unit) { build :unit }
  let(:unit2) { build :unit }
  let(:base_unit) {build :unit, number: 0, membership_fee: 2}
  let(:user) { build :user, unit:, joined_date: Date.today - 1008 }
  let(:user_volunteer) {build :user, unit:, joined_date: Date.today - 100, volunteer: true}
  let(:event) { build :event, unit: }
  let(:registration) { build :event_registration, user:, event: }
  let(:user2) { build :user, unit: }
  let(:payment) { build :membership_fee_payment, unit:, user_payed: user, user_recorded: user2 }
  let(:position) { build :position, unit:, user:, position_name: 'Nodarbību vadītājs' }
  let(:rank_current) { build :rank_history, { rank: 'SK/G', current: true, user: } }
  let(:rank_current_volunteer) { build :rank_history, { rank: 'SK/G', current: true, user: user_volunteer} }
  let(:rank_old) { build :rank_history, { rank: 'MZSK/GNT', current: false, user: } }
  let(:event) { build :event, unit: unit, date_from: Date.today + 200, necessary_volunteers: 10, registered_volunteers: 2 }
  let(:event2) { build :event, unit: unit, date_from: Date.today + 200,necessary_volunteers: 10, registered_volunteers: 2 }
  let(:invite) { build :invite, event:, unit: unit, rank: 'SK/G' }
  let(:invite2) { build :invite, event: event2, unit: unit, rank: 'MZSK/GNT' }
  let(:invite3) { build :invite, event:, unit: unit2, rank: 'SK/G' }

  it('should fill default attributes with default values') do
    user = User.new
    expect(user).not_to be_valid
    expect(user.membership_fee_bilance).to eq(0)
    expect(user.permission_level).to eq('pklv_biedrs')
  end

  it('should be valid with valid attributes') do
    expect(user).to be_valid
  end

  it('should be valid without nullable fields') do
    user.phone = nil
    user.email = nil
    user.birth_date = nil
    user.sex = nil
    expect(user).to be_valid
  end

  it('should be invalid without not nullable fields') do
    user.name = nil
    user.surname = nil
    user.activity_statuss = nil
    user.membership_fee_bilance = nil
    user.joined_date = nil
    user.permission_level = nil
    expect(user).not_to be_valid
  end

  it('should get users units information') do
    expect(user.unit).to eq(unit)
  end

  it('should get users payed membership fee data') do
    unit.save!
    user.save!
    user2.save!
    payment.save!

    expect(user.payed_fees).to eq([payment])
    expect(user2.payed_fees).to eq([])
  end

  it('should get users registed membership fee data') do
    unit.save!
    user.save!
    user2.save!
    payment.save!

    expect(user.registered_fees).to eq([])
    expect(user2.registered_fees).to eq([payment])
  end

  it('should get users registered events information') do
    event.save!
    registration.save!

    expect(user.events.first).to eq(event)
  end

  it('should get users positions') do
    position.save!

    expect(user.positions.first).to eq(position)
  end

  it('should get users current rank and rank history') do
    user.save!
    rank_current.save!
    rank_old.save!

    expect(user.rank).to eq('SK/G')
    expect(user.rank_histories.length).to eq(2)
  end

  it('should get users time in organization') do
    user.save!

    expect(user.years_in_organization).to eq(2)
  end

  it('should reduce the bilance by membership fee') do
    unit.membership_fee = 2
    unit.save!
    base_unit.save!
    user.save!

    user.recalculate_bilance

    expect(user.membership_fee_bilance).to eq(-4)
  end

  it('should return all upcomming events with organization scope for volunteers') do
    unit.save!
    user_volunteer.save!
    event.save!
    event2.save!
    invite.save!
    
    expect(user_volunteer.available_events.length).to eq(2)
  end

  it('should return only aplicable events with invited unit scope for volunteers') do
    unit.save!
    unit2.save!
    user_volunteer.unit = unit2
    user_volunteer.save!
    
    #Pirmais event tiek rādīts tikai vienībām kas ir ielūgtas
    event.volunteer_scope = "Ielūgtās vienības" 
    event.save!
    event2.save!
    invite.save!
    
    expect(user_volunteer.available_events.length).to eq(1)

    invite3.save!

    expect(user_volunteer.available_events.length).to eq(2)
  end


  it('should return only units events with unit scope for volunteers') do
    unit.save!
    unit2.save!
    user_volunteer.unit = unit2
    user_volunteer.save!
    rank_current_volunteer.rank = "VAD"
    rank_current_volunteer.save!
    event.volunteer_scope = "Vienība" 
    event.save!
    event2.save!
    invite.save!
    
    expect(user_volunteer.available_events.length).to eq(1)

    invite3.save!

    expect(user_volunteer.available_events.length).to eq(1)

    user_volunteer.unit = unit
    user_volunteer.save!

    expect(user_volunteer.available_events.length).to eq(2)
  end

  it('should return only applicable upcomming events for non volunteers') do
    unit.save!
    user.save!
    rank_current.save!
    event.save!
    event2.save!
    invite.save!
    
    expect(user.available_events.length).to eq(1)
    expect(user.available_events[0]).to eq(event)
  end

  it('should not return unpublishable events for volunteers or non volunteers') do
    unit.save!
    user.save!
    user_volunteer.save!
    rank_current.save!
    rank_current_volunteer.save!
    event.publishable = false
    event2.publishable = false
    event.save!
    event2.save!
    invite.save!
    
    expect(user.available_events.length).to eq(0)
    expect(user_volunteer.available_events.length).to eq(0)
  end

end
