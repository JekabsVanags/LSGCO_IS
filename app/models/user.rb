class User < ApplicationRecord
  has_secure_password #Paroles šifrēšana (bcrypt gem)

  #Definējam obligātos laukus
  validates :name, :surname, :activity_statuss, :membership_fee_bilance, :joined_date, :permission_level, presence: true

  #Definējam iespējamās vērtības
  enum activity_statuss: ["Aktīvs", "Daļēji aktīvs", "Interesents", "Vadītājs", "Vecbiedrs", "Neaktīvs", "Izstājies"]
  enum sex: ["M", "F", "O"]
  enum permission_level: ["pklv_biedrs", "pklv_vaditajs", "pklv_valde"]

  #Objektu saistības
  has_many :rank_histories
  has_one :personal_information, dependent: :destroy
  belongs_to :unit
  has_one :leader_for_unit, foreign_key: "unit_leader_id", class_name: "Unit"

  has_many :event_registrations
  has_many :events, through: :event_registrations

  has_many :payed_fees, foreign_key: "user_payed_id", class_name: "MembershipFeePayment"
  has_many :registered_fees, foreign_key: "user_recorded_id", class_name: "MembershipFeePayment"

  has_many :positions

  def years_in_organization #Pilni gadi organizācijā. 365.25 dienas gadā ņemot vērā garos gadus.
    ((Date.today - joined_date) / 365.25).to_i
  end

  def full_name
    "#{name} #{surname}"
  end

  def rank #Pašreiz aktīvā pakāpe
    history = rank_histories.where(current: true).first
    history ? history.rank : "Tev nav norādīta pakāpe"
  end

  def youth? #Vai ir dižskauts vai vecāks
    ["DZSK/DZG", "ROV/LG", "VAD", "VIEDSK/VIEDG"].include?(rank)
  end

  def promise? #Vai pašreizējā pakāpe ir ar solījuma datumu, atgriež datumu
    history = rank_histories.where(current: true).first
    history.present? ? history.date_of_oath : false
  end

  def recalculate_bilance #Pārrēķina bilanci, tiek izsaukta automātiski
    if activity_statuss == "Neaktīvs" || activity_statuss == "Izstājies" #Ja lietotājs nav aktīvs, pārtraucam funkciju
      return nil
    end

    bilance = membership_fee_bilance
    org_fee = Unit.find_by(number: 0).membership_fee
    full_fee = org_fee ? org_fee : 0 #Visiem lietotājiem jāmaksā organizācijas dalības maksa

    if activity_statuss != "Daļēji aktīvs" #Lietotājiem kas ir aktīvi jāmaksā arī vienības dalības maksa
      full_fee += unit.membership_fee ? unit.membership_fee : 0
    end

    #Atjauno bilances datus DB
    new_bilance = bilance - full_fee
    update(membership_fee_bilance: new_bilance)
    reload
  end

  def available_events #Aktuālo pasākumu sarakstss
    events = unit.get_actual_events(self) #Vienības aktuālie pasākumi lietotāja pakāpei

    if volunteer #Ja lietotājs ir brīvprātīgais pievieno visus pasākumus kam vajadzīgi brīvprātīgie
      global_events = Event.future.select { |event| event.publishable && event.volunteer_scope == "Organizācija"}
      events.concat(global_events)
    end

    events.each do |event| #Sarakstā atzīmējam uz kuriem pasākumiem lietotājs ir reģistrējies
      event.registered = event_registrations.exists?(event: event)
    end

    return events.uniq #Atgriežam tikai unikālos ierakstus
  end
end
