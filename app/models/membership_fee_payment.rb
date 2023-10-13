class MembershipFeePayment < ApplicationRecord
  has_one :user_recorded, :
  has_one :user_payed
  has_one :unit
end
