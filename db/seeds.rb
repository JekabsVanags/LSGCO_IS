if Rails.env.development?
    org_unit = Unit.create(city: "Latvia", number: 0, legal_adress: "Edvarda Smiļģa iela 48", email: "info@skautiungaidas.lv", bank_account: "GB59BARC20038041146187", membership_fee: "0")
    admin = User.create(name: "Jekabs", surname: "Vanags", activity_statuss: "Aktīvs", joined_date: Date.today, password_digest: BCrypt::Password.create("test").to_s, agreed_to_data_collection: true, unit: org_unit, username: "JVanags29")
end