class Unit < ApplicationRecord
  #Definējam obligātos laukus
  validates :city, :number, :legal_adress, :bank_account, presence: true

  #Objektu saistības
  belongs_to :unit_leader, class_name: "User", optional: true

  has_many :users, foreign_key: 'unit_id'
  has_many :events
  has_many :invites
  has_many :event_invites, through: :invites, source: :event
  has_many :membership_fee_payments
  has_many :positions
  has_many :weekly_activities

  def full_name #Vienības pilnais nosaukums
    if number == 0 
      "LSGCO"
    elsif city.ends_with?("i")
      "#{city.slice(0...-1)}u #{number}. vienība"
    elsif city.ends_with?("ls")
      "#{city} #{number}. vienība"
    elsif city.ends_with?("s")
      "#{city.slice(0...-1)}a #{number}. vienība"
    else
      "#{city}s #{number}. vienība"
    end
  end

  def get_actual_events(user) #Pasākumi, kuriem vienībai ir ielūgumi norādītajai pakāpei
    events = invites.includes(:event).future.where(rank: user.rank).map(&:event).select { |event| event.publishable }

    if(user.volunteer == true)
      volunteer_events = invites.includes(:event).future.where("necessary_volunteers >= registered_volunteers").map(&:event).select { |event| 
      event.publishable && 
      event.volunteer_scope == "Ielūgtās vienības" || 
      event.volunteer_scope == "Vienība" && event.unit == user.unit}

      events.concat(volunteer_events)
    end

    return events
  end

  def unit_active? #Vai vienība ir dzēsta
    !deleted_at.present?
  end
end
