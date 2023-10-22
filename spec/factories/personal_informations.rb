FactoryBot.define do
  factory :personal_information do
    user { nil }
    address { Faker::Address.full_address }
    emergency_contact_number { Faker::PhoneNumber.phone_number }
    emergency_contact_relationship { 1 }
    health_issues { 'MyText' }
    medication_during_event { 'MyText' }
    psychological_features { 'MyText' }
    diet { 'MyText' }
  end
end
