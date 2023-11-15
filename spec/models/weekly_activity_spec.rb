require "rails_helper"

RSpec.describe WeeklyActivity, type: :model do
  let(:unit) { build :unit }

  it("should validate weekly activity") do
    expect(WeeklyActivity.new(unit: unit, time: Time.now, day: "Pirmdiena", rank: "Mazskauti/Guntiņas")).to be_valid
  end

  it("shouldnt validate weekly activity with wrong day or rank") do
    expect { WeeklyActivity.new(unit: unit, time: Time.now, day: "TESTS", rank: "Mazskauti/Guntiņas") }.to raise_error(ArgumentError)
    expect { WeeklyActivity.new(unit: unit, time: Time.now, day: "Pirmdiena", rank: "TEST") }.to raise_error(ArgumentError)
  end
end
