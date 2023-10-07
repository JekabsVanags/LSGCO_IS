FactoryBot.define do
  factory :event do
    unit { nil }
    name { "MyString" }
    description { "MyText" }
    date_from { "2023-10-07" }
    date_to { "2023-10-07" }
    event_type { 1 }
    necessary_volunteers { 1 }
    registered_volunteers { 1 }
    max_participants { 1 }
    registered_participants { 1 }
    deleted_at { "2023-10-07" }
  end
end
