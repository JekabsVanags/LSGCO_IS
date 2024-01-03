class PersonalInformation < ApplicationRecord
  enum emergency_contact_relationship: ["Tēvs", "Māte", "Vecvecāks", "Dzīvesbiedrs"]

  belongs_to :user
end
