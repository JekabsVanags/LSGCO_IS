FactoryBot.define do
  factory :event do
    unit { nil }
    name { "MyString" }
    description { "MyText" }
    date_from { Faker::Date.in_date_period(year: 2020) }
    date_to { Faker::Date.in_date_period(year: 2020) }
    event_type { 1 }
    necessary_volunteers { 2 }
    registered_volunteers { 0 }
    max_participants { 10 }
    registered_participants { 0 }
    deleted_at { nil }
  end
end
