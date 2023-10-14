class User < ApplicationRecord
  has_secure_password
  validates :name, :surname, :activity_statuss, :membership_fee_bilance, :joined_date, :permission_level, presence: true

  enum activity_statuss: ["aktīvs", "interesents", "vecbiedrs"]
  enum sex: ["M", "F", "O"]
  enum permission_level: ["biedrs", "vaditajs", "valde"]

  has_many :rank_histories
  has_one :personal_informations, dependent: :destroy
  belongs_to :unit

  has_many :event_registrations
  has_many :events, through: :event_registrations
  
  has_many :payed_fees, foreign_key: "user_payed_id", class_name: "MembershipFeePayment"
  has_many :registered_fees, foreign_key: "user_recorded_id", class_name: "MembershipFeePayment"

  def years_in_organization
    ((Date.today - joined_date)/365).to_i
  end
end
