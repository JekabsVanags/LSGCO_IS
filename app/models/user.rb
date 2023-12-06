class User < ApplicationRecord
  has_secure_password
  validates :name, :surname, :activity_statuss, :membership_fee_bilance, :joined_date, :permission_level, presence: true

  enum activity_statuss: ["Aktīvs", "Daļēji aktīvs", "Interesents", "Vadītājs", "Vecbiedrs", "Izstājies"]
  enum sex: ["M", "F", "O"]
  enum permission_level: ["pklv_biedrs", "pklv_vaditajs", "pklv_valde"]

  has_many :rank_histories
  has_one :personal_information, dependent: :destroy
  belongs_to :unit

  has_many :event_registrations
  has_many :events, through: :event_registrations

  has_many :payed_fees, foreign_key: "user_payed_id", class_name: "MembershipFeePayment"
  has_many :registered_fees, foreign_key: "user_recorded_id", class_name: "MembershipFeePayment"

  has_many :positions

  scope :active_members, -> { where(:activity_statuss != "Izstājies") }
  scope :ex_members, -> { where(:activity_statuss == "Izstājies") }

  def years_in_organization
    ((Date.today - joined_date) / 365).to_i
  end

  def rank
    history = rank_histories.where(current: true).first
    history ? history.rank : "Tev nav norādīta pakāpe"
  end

  def promise?
    history = rank_histories.where(current: true).first
    history.present? ? history.date_of_oath : false
  end

  def recalculate_bilance()
    bilance = membership_fee_bilance
    fee = Unit.find_by(number: 0).membership_fee
    if activity_statuss != "Daļēji aktīvs"
      fee += unit.membership_fee
    end
    new_bilance = bilance - fee
    update(membership_fee_bilance: new_bilance)
    reload
  end

  def available_events
    events = unit.get_actual_events(rank)

    if volunteer
      future_events = Event.future.where("necessary_volunteers >= registered_volunteers")
      events.concat(future_events)
    end

    events.each do |event|
      event.registered = event_registrations.exists?(event: event)
    end

    return events.uniq
  end
end
