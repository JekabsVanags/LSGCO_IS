class Event < ApplicationRecord
  enum event_type: ["Nometne", "Pārgājiens", "Darba grupa", "Labais darbs", "Cits"] 
  belongs_to :unit
end
