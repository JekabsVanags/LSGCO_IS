FactoryBot.define do
  factory :rank_history do
    rank { 1 }
    user { nil }
    current { false }
    date_begin { Faker::Date.in_date_period(year: 2020) }
    date_of_oath { Faker::Date.in_date_period(year: 2020) }
  end
end
