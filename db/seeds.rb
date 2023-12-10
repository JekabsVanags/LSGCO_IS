require "json"
require "bcrypt"
require "faker"

def generate_fake_user(unit, rank)
  user = User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, activity_statuss: "Aktīvs", joined_date: Date.today,
                     password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit,
                     username: "#{Faker::Name.first_name}#{Faker::Name.last_name}#{unit.id}", permission_level: "pklv_biedrs", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
  RankHistory.create(date_begin: (Date.today - 1075), user: user, rank: rank)
end

if Rails.env.development?
  org_unit = Unit.create(city: "Latvija", number: 0, legal_adress: "Org Unit Address",
                         email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "0")

  ogre_unit = Unit.create(city: "Ogre", number: 29, legal_adress: "Ogre Unit Address",
                          email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "2")

  tukums_unit = Unit.create(city: "Tukums", number: 12, legal_adress: "Tukums Unit Address",
                            email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "3")

  admin_user = User.create(name: "Jekabs", surname: "Vanags", activity_statuss: "Vadītājs", joined_date: Date.today,
                           password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: ogre_unit,
                           username: "JekabsVanags29", permission_level: "pklv_valde")
  RankHistory.create(date_begin: (Date.today - 1075), user: admin_user, rank: "DZSK/DZG")

  12.times do
    generate_fake_user(ogre_unit, "MZSK/GNT")
  end
  10.times do
    generate_fake_user(ogre_unit, "SK/G")
  end
  2.times do
    generate_fake_user(ogre_unit, "DZSK/DZG")
  end

  12.times do
    generate_fake_user(tukums_unit, "MZSK/GNT")
  end
  10.times do
    generate_fake_user(tukums_unit, "SK/G")
  end
  2.times do
    generate_fake_user(tukums_unit, "DZSK/DZG")
  end

  test_event1 = Event.create(name: "Nometne", description: Faker::Books::Lovecraft.paragraph, date_from: (Date.today + 60), date_to: (Date.today + 60), event_type: "Nometne", unit: org_unit)
  test_event2 = Event.create(name: "Pārgājiens", description: Faker::Books::Lovecraft.paragraph, date_from: (Date.today + 90), date_to: (Date.today + 60), event_type: "Pārgājiens", unit: org_unit)
  test_event3 = Event.create(name: "Pārgājiens mazajiem", description: Faker::Books::Lovecraft.paragraph, date_from: (Date.today + 90), date_to: (Date.today + 60), event_type: "Pārgājiens", unit: ogre_unit)
  Invite.create(event: test_event1, unit: ogre_unit, rank: "DZSK/DZG")
  Invite.create(event: test_event2, unit: ogre_unit, rank: "DZSK/DZG")
  Invite.create(event: test_event3, unit: ogre_unit, rank: "MZSK/GNT")
end
