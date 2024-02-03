class MembershipFeePayment < ApplicationRecord
  validates :date, :amount, :org_fee, :user_statuss, presence: true

  belongs_to :user_recorded, foreign_key: "user_recorded_id", class_name: "User"
  belongs_to :user_payed, foreign_key: "user_payed_id", class_name: "User"
  belongs_to :unit
end
