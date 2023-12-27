require "json"
require "bcrypt"
require "faker"

org_unit = Unit.create(city: "Latvija", number: 0, legal_adress: "Org Unit Address",
                       email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "0")

def random_seeder
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

def bdr_test_seeder
  unit_a = Unit.create(city: "Ogre", number: 29, legal_adress: "Ogre Unit Address",
                       email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "10")
  unit_b = Unit.create(city: "Valka", number: 52, legal_adress: "Valka Unit Address",
                       email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "10")

  user = User.create(name: "Test", surname: "User", activity_statuss: "Aktīvs", joined_date: Date.today,
                     password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit_a,
                     username: "TestUser29", permission_level: "pklv_biedrs", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
  RankHistory.create(date_begin: (Date.today - 1075), user: user, rank: "SK/G")

  test_event_a = Event.create(name: "P/A", description: Faker::Books::Lovecraft.paragraph, date_from: (Date.today + 60), date_to: (Date.today + 60), event_type: "Nometne", unit: unit_b, necessary_volunteers: 10, max_participants: 10)
  Invite.create(event: test_event_a, unit: unit_a, rank: "SK/G")
  test_event_b = Event.create(name: "P/B", description: Faker::Books::Lovecraft.paragraph, date_from: (Date.today + 60), date_to: (Date.today + 60), event_type: "Nometne", unit: unit_b, necessary_volunteers: 10, max_participants: 10, registered_participants: 10)
  Invite.create(event: test_event_b, unit: unit_a, rank: "SK/G")
  test_event_c = Event.create(name: "P/C", description: Faker::Books::Lovecraft.paragraph, date_from: (Date.today + 60), date_to: (Date.today + 60), event_type: "Nometne", unit: unit_b, necessary_volunteers: 10, max_participants: 10)
  test_event_d = Event.create(name: "P/D", description: Faker::Books::Lovecraft.paragraph, date_from: (Date.today + 60), date_to: (Date.today + 60), event_type: "Nometne", unit: unit_a, necessary_volunteers: 10, max_participants: 10)
end

def vnb_test_seeder
  unit_a = Unit.where(number: 29).first

  user_a = User.create(name: "Test2", surname: "User", activity_statuss: "Aktīvs", joined_date: Date.today,
                       password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit_a,
                       username: "Test2User29", permission_level: "pklv_vaditajs", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
  RankHistory.create(date_begin: (Date.today - 1075), user: user_a, rank: "SK/G")

  user_b = User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, activity_statuss: "Aktīvs", joined_date: Date.today,
                       password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit_a,
                       username: "123", permission_level: "pklv_biedrs", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
  RankHistory.create(date_begin: (Date.today - 1075), user: user_b, rank: "MZSK/GNT", date_of_oath: Date.today - 200)

  user_c = User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, activity_statuss: "Aktīvs", joined_date: Date.today,
                       password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit_a,
                       username: "324", permission_level: "pklv_biedrs", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
  RankHistory.create(date_begin: (Date.today - 1075), user: user_c, rank: "SK/G", date_of_oath: Date.today - 200)

  user_d = User.create(name: "Jānis", surname: "Bērziņš", activity_statuss: "Daļēji aktīvs", joined_date: Date.today,
                       password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit_a,
                       username: "567", permission_level: "pklv_biedrs", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
  RankHistory.create(date_begin: (Date.today - 1075), user: user_d, rank: "DZSK/DZG")
end

def vld_test_seeder
  unit_a = Unit.where(number: 29).first
  unit_c = Unit.create(city: "Ciemupe", number: 32, legal_adress: "Ciemupe Unit Address",
                       email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "10")
  unit_d = Unit.create(city: "Jelgava", number: 72, legal_adress: "Jelgava Unit Address",
                       email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "10")

  user_a = User.create(name: "Test3", surname: "User", activity_statuss: "Aktīvs", joined_date: Date.today,
                       password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit_a,
                       username: "Test3User29", permission_level: "pklv_valde", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
  RankHistory.create(date_begin: (Date.today - 1075), user: user_a, rank: "SK/G")

  user_b = User.create(name: "Jānis", surname: "Kļaviņš", activity_statuss: "Vadītājs", joined_date: Date.today,
                       password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit_a,
                       username: "Kļaviņš", permission_level: "pklv_biedrs", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
  RankHistory.create(date_begin: (Date.today - 1075), user: user_a, rank: "SK/G")
end

def generate_fake_user(unit, rank)
  user = User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, activity_statuss: "Aktīvs", joined_date: Date.today,
                     password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit,
                     username: "#{Faker::Name.first_name}#{Faker::Name.last_name}#{unit.id}", permission_level: "pklv_biedrs", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
  RankHistory.create(date_begin: (Date.today - 1075), user: user, rank: rank)
end

if Rails.env.development?
  bdr_test_seeder()
  vnb_test_seeder()
  vld_test_seeder()
end
