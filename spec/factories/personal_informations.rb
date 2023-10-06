FactoryBot.define do
  factory :personal_information do
    user { nil }
    address { "MyString" }
    emergency_contact_number { "MyString" }
    emergency_contact_relationship { 1 }
    health_issues { "MyText" }
    medication_during_event { "MyText" }
    psychological_features { "MyText" }
    diet { "MyText" }
  end
end
