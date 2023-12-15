class Invite < ApplicationRecord
  belongs_to :unit
  belongs_to :event
  validates :rank, presence: true

  enum rank: ["MZSK/GNT", "SK/G", "DZSK/DZG", "ROV/LG", "VAD", "VIEDSK/VIEDG", "CITS"]

  scope :future, -> { joins(:event).where("events.date_from > ?", Date.today) }
end
