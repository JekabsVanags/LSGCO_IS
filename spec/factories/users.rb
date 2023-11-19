FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    surname { Faker::Name.name }
    activity_statuss { "Aktīvs" }
    joined_date { DateTime.now - 1 }
    password_digest { BCrypt::Password.create(Faker::Internet.password).to_s }
    agreed_to_data_collection { true }
    volunteer { false }
  end
end
