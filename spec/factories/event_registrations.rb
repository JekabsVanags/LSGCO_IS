FactoryBot.define do
  factory :event_registration do
    user { nil }
    event { nil }
    role { 1 }
    position { "MyString" }
    private_info_permission { false }
  end
end
