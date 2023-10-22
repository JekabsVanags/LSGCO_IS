class PersonalInformation < ApplicationRecord
  enum emergency_contact_relationship: %w[Tēvs Māte Vecvecāks Dzīvesbiedrs]
  belongs_to :user
end
