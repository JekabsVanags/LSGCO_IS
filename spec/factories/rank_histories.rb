FactoryBot.define do
  factory :rank_history do
    rank { 1 }
    user { nil }
    current { false }
    date_begin { "2023-10-06" }
    date_of_oath { "2023-10-06" }
  end
end
