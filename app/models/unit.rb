class Unit < ApplicationRecord
  #Definējam obligātos laukus
  validates :city, :number, :legal_adress, :bank_account, presence: true

  #Objektu saistības
  has_many :users, foreign_key: 'unit_id'
  has_many :events
  has_many :invites
  has_many :event_invites, through: :invites, source: :event
  has_many :membership_fee_payments
  has_many :positions
  has_many :weekly_activities

  def full_name #Vienības pilnais nosaukums
    number == 0 ? "LSGCO" : "#{city}s #{number}. vienība"
  end

  def get_actual_events(rank) #Pasākumi, kuriem vienībai ir ielūgumi norādītajai pakāpei
    invites.includes(:event).future.where(rank:).map(&:event)
  end

  def unit_leader #Vienības priekšnieks- lietotājs kam ir vadītāja piekļuve, vai arī valdes piekļuve un vadītāja pakāpe.
    users.where(permission_level: "pklv_vaditajs").first || users.where(permission_level: "pklv_valde", activity_statuss: "Vadītājs").first
  end

  def unit_active? #Vai vienība ir dzēsta
    !deleted_at.present?
  end
end
