if Rails.env.development?
  org_unit = Unit.create(city: 'Latvija', number: 0, legal_adress: 'Edvarda Smiļģa iela 48',
    email: 'info@skautiungaidas.lv', bank_account: 'GB59BARC20038041146187', membership_fee: '0')
  test_unit = Unit.create(city: 'Ogre', number: 29, legal_adress: 'Edvarda Smiļģa iela 48',
    email: 'info@skautiungaidas.lv', bank_account: 'GB59BARC20038041146187', membership_fee: '0')
  admin_user = User.create(name: 'Jekabs', surname: 'Vanags', activity_statuss: 'Aktīvs', joined_date: Date.today,
    password_digest: BCrypt::Password.create('test').to_s, agreed_to_data_collection: true, unit: test_unit, username: 'JekabsVanags29', permission_level: 'pklv_vaditajs')
  RankHistory.create(date_begin: (Date.today - 1075), user: admin_user, rank: 'DZSK/DZG')
  test_event1 = Event.create(name: 'Nometne', date_from: (Date.today + 60), event_type: 'Nometne', unit: org_unit)
  test_event2 = Event.create(name: 'Pārgājiens', date_from: (Date.today + 90), event_type: 'Pārgājiens', unit: org_unit)
  Invite.create(event: test_event1, unit: test_unit, rank: 'DZSK/DZG')
  Invite.create(event: test_event2, unit: test_unit, rank: 'DZSK/DZG')
end
