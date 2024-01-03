class Event < ApplicationRecord
  validates :name, :date_from, :date_to, :event_type, presence: true

  enum event_type: ["Nometne", "Pārgājiens", "Darba grupa", "Labais darbs", "Cits"]

  belongs_to :unit
  has_many :invites
  has_many :invited_units, through: :invites, source: :unit
  has_many :event_registrations
  has_many :users, through: :event_registrations

  #Papildus parametrs lai norādītu vai lietotājs ir reģistrējies pasākumam to uzskaitē
  attr_accessor :registered

  #Nestingrā dzēšana- noklusējumā rādam tikai nedzēstos pasākumus
  default_scope { where(deleted_at: nil) }
  #Nākotnes pasākumi
  scope :future, -> { where("date_from > ?", Date.today) }
end
