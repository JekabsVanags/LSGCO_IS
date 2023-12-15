class Event < ApplicationRecord
  enum event_type: ["Nometne", "Pārgājiens", "Darba grupa", "Labais darbs", "Cits"]
  validates :name, :date_from, :date_to, :event_type, presence: true

  belongs_to :unit

  has_many :invites
  has_many :invited_units, through: :invites, source: :unit
  has_many :event_registrations
  has_many :users, through: :event_registrations

  attr_accessor :registered

  default_scope { where(deleted_at: nil) }
  scope :future, -> { where("date_from > ?", Date.today) }
end
