FactoryBot.define do
  factory :rank_history do
    rank { 1 }
    user { nil }
    current { false }
    date_begin { Faker::Date.past }
    date_of_oath { Faker::Date.past }
  end
end
