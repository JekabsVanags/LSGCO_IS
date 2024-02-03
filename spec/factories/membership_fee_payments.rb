FactoryBot.define do
  factory :membership_fee_payment do
    date { "2023-10-13" }
    amount { "9.99" }
    org_fee { "1.99" }
    user_statuss { 1 }
    user_recorded { nil }
    user_payed { nil }
    unit { nil }
  end
end
