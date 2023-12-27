require 'rails_helper'

RSpec.describe PersonalInformation, type: :model do
  let(:unit) { build :unit }
  let(:user) { build :user, unit: }

  it('should validate an empty personal information with user') do
    expect(PersonalInformation.new(user:)).to be_valid
  end
end
