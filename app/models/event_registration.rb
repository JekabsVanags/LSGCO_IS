class EventRegistration < ApplicationRecord
  validates :role, presence: true
  validates_inclusion_of :private_info_permission, in: [true, false]

  belongs_to :user
  belongs_to :event

  enum role: %w[Dalībnieks Brīvprātīgais Organizētājs]
end
