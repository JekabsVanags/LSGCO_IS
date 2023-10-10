require 'rails_helper'

RSpec.describe RankHistory, type: :model do
  let(:unit) { build :unit }
  let(:user) { build :user, unit: unit }

  it("should return an error if not a valid rank") do
    expect {RankHistory.new(rank: "ERRORS")}.to raise_error(ArgumentError) 
  end

  it("should create and save a valid rank") do
    rank = RankHistory.new(rank: "MZSK/GNT", date_begin: Date.today, user: user)
    expect(rank.save!).to be(true)
  end

end
