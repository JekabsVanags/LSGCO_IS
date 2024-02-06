require "json"
require "bcrypt"
require "faker"

org_unit = Unit.create(city: "Latvija", number: 0, legal_adress: "Org Unit Address",
                       email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "10")

def demonstration_seeder
  ogre_unit = Unit.create(city: "Ogre", number: 29, legal_adress: "Ogre Unit Address",
  email: "ogre@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "3")

  ogre_admin_user = User.create(name: "Agnese", surname: "Zīmele", activity_statuss: "Vadītājs", joined_date: Date.today,
  password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: ogre_unit,
  username: "AgneseZīmele29", permission_level: "pklv_vaditajs")

  ogre_unit.unit_leader = ogre_admin_user
  ogre_unit.save!

  tukums_unit = Unit.create(city: "Tukums", number: 12, legal_adress: "Tukums Unit Address",
    email: "tukums@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "3")
  
  tukums_admin_user = User.create(name: "Inga", surname: "Kuple", activity_statuss: "Vadītājs", joined_date: Date.today,
  password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: tukums_unit,
  username: "IngaKuple12", permission_level: "pklv_vaditajs")

  tukums_unit.unit_leader = tukums_admin_user
  tukums_unit.save!

  riga_unit = Unit.create(city: "Rīga", number: 2, legal_adress: "Rigas 2. Unit Address",
    email: "rigas2@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "3")

  riga_admin_user = User.create(name: "Madara", surname: "Skudra", activity_statuss: "Vadītājs", joined_date: Date.today,
  password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: tukums_unit,
  username: "MadaraSkudra2", permission_level: "pklv_vaditajs")

  riga_unit.unit_leader = riga_admin_user
  riga_unit.save!

  admin_user = User.create(name: "Jēkabs", surname: "Vanags", activity_statuss: "Aktīvs", joined_date: Date.today,
                           password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: ogre_unit,
                           username: "JēkabsVanags29", permission_level: "pklv_valde")
end

def random_seeder
  ogre_unit = Unit.create(city: "Ogre", number: 29, legal_adress: "Ogre Unit Address",
                          email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "2")

  tukums_unit = Unit.create(city: "Tukums", number: 12, legal_adress: "Tukums Unit Address",
                            email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "3")

  admin_user = User.create(name: "Jekabs", surname: "Vanags", activity_statuss: "Vadītājs", joined_date: Date.today,
                           password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: ogre_unit,
                           username: "JekabsVanags29", permission_level: "pklv_valde")
  
  admin2_user = User.create(name: "Andris", surname: "Vanags", activity_statuss: "Vadītājs", joined_date: Date.today,
                           password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: ogre_unit,
                           username: "AndrisVanags12", permission_level: "pklv_vaditajs")

  RankHistory.create(date_begin: (Date.today - 1075), user: admin_user, rank: "DZSK/DZG")

  ogre_unit.unit_leader = admin_user
  ogre_unit.save!

  tukums_unit.unit_leader = admin2_user
  tukums_unit.save!

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
end

def bdr_test_seeder
  unit_a = Unit.create(city: "Ogre", number: 29, legal_adress: "Ogre Unit Address",
                       email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "10")
  unit_b = Unit.create(city: "Valka", number: 52, legal_adress: "Valka Unit Address",
                       email: "info@skautiungaidas.lv", phone: "23232323", bank_account: "GB59BARC20038041146187", membership_fee: "10")

  user = User.create(name: "Jēkabs", surname: "Vanags", activity_statuss: "Aktīvs", joined_date: Date.today,
                     password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit_a,
                     username: "JēkabsVanags29", permission_level: "pklv_biedrs", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
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

  user_a = User.create(name: "Agnese", surname: "Zīmele", activity_statuss: "Aktīvs", joined_date: Date.today,
                       password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit_a,
                       username: "AgneseZīmele29", permission_level: "pklv_vaditajs", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
  RankHistory.create(date_begin: (Date.today - 1075), user: user_a, rank: "VAD")

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

  user_a = User.create(name: "Inga", surname: "Kuple", activity_statuss: "Aktīvs", joined_date: Date.today,
                       password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: unit_a,
                       username: "IngaKuple29", permission_level: "pklv_valde", phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email)
  RankHistory.create(date_begin: (Date.today - 1075), user: user_a, rank: "VAD")

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
   demonstration_seeder()
  # random_seeder()
  # bdr_test_seeder()
  # vnb_test_seeder()
  # vld_test_seeder()
end
