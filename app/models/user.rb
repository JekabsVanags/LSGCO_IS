class User < ApplicationRecord
  has_secure_password

  enum activity_statuss: ["aktīvs", "interesents", "vecbiedrs"]
  enum sex: ["M", "F", "O"]
  enum permission_level: ["biedrs", "vaditajs", "valde"]

  has_many :rank_history, dependent: :destroy
  has_one :personal_informations, dependent: :destroy

  def years_in_organization
    ((Date.today - joined_date)/365).to_i
  end
end
