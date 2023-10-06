FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    surname {Faker::Name.name}
    rank {"MZSK/GNT"}
    promise {false}
    activity_statuss {'aktīvs'}
    joined_date {Date.today - 200}
    password_digest {Faker::Internet.password}
    agreed_to_data_collection {true}
  end
end
