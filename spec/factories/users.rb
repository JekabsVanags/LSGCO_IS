FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    surname {Faker::Name.name}
    activity_statuss {'aktīvs'}
    joined_date {DateTime.now - 1 }
    password_digest {Faker::Internet.password}
    agreed_to_data_collection {true}
  end
end
