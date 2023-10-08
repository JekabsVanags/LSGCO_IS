FactoryBot.define do
  factory :unit do
    city { "MyString" }
    number { 1 }
    legal_adress { "MyString" }
    activity_location_name { "MyString" }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    comments { "MyText" }
    bank_account { Faker::PhoneNumber.phone_number }
    membership_fee { "2" }
  end
end
