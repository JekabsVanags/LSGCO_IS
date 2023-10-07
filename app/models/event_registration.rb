class EventRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum role: ["Dalībnieks", "Brīvprātīgais", "Organizētājs"]
end
