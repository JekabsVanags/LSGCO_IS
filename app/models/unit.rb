class Unit < ApplicationRecord
  validates :city, :number, :legal_adress, :bank_account, presence: true

  has_many :users, foreign_key: 'unit_id'
  has_many :events
  has_many :invites
  has_many :event_invites, through: :invites, source: :event
  has_many :membership_fee_payments
  has_many :positions
  has_many :weekly_activities
  def full_name
    number == 0 ? "LSGCO" : "#{city}s #{number}. vienība"
  end

  def get_actual_events(rank)
    invites.future.where(rank:).map(&:event)
  end

  def unit_leader
    users.where(unit: @unit, permission_level: "pklv_vaditajs").first || users.where(permission_level: "pklv_valde", activity_statuss: "Vadītājs").first
  end

  def unit_active?
    !deleted_at.present?
  end
end
