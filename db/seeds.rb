if Rails.env.development?
    org_unit = Unit.create(city: "Latvia", number: 0, legal_adress: "Edvarda Smiļģa iela 48", email: "info@skautiungaidas.lv", bank_account: "GB59BARC20038041146187", membership_fee: "0")
    admin = User.create(name: "Jekabs", surname: "Vanags", activity_statuss: "aktīvs", joined_date: Date.today, password_digest: "tests", agreed_to_data_collection: true, unit: org_unit)
end