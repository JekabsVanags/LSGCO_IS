FactoryBot.define do
  factory :unit do
    city { "MyString" }
    number { 1 }
    legal_adress { "MyString" }
    activity_location_name { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    comments { "MyText" }
    bank_account { "MyText" }
    deleted_at { "2023-10-06" }
    membership_fee { "9.99" }
  end
end
