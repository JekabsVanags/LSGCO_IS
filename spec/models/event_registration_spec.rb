require 'rails_helper'

RSpec.describe EventRegistration, type: :model do
  let(:unit) { build :unit }
  let(:user) { build :user, unit: }
  let(:event) { build :event, unit: }
  let(:reg) { build :event_registration, user:, event: }

  it('should be valid without nullable fields') do
    reg.position = nil
    expect(reg).to be_valid
  end

  it('should be invalid without not nullable fields') do
    reg.role = nil
    reg.private_info_permission = nil
    expect(reg).not_to be_valid
  end

  it('should fill in default values') do
    reg = EventRegistration.new

    expect(reg.private_info_permission).to eq(false)
  end

  it('should throw error if unrecognized role entered') do
    expect { EventRegistration.new(role: 'ERROR') }.to raise_error(ArgumentError)
  end
end
