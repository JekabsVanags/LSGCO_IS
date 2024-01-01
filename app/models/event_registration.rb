class EventRegistration < ApplicationRecord
  validates :role, presence: true
  validates_inclusion_of :private_info_permission, in: [true, false] #Atļauts vai neatļauts

  enum role: ["Dalībnieks", "Brīvprātīgais", "Organizētājs"]

  belongs_to :user
  belongs_to :event
end
