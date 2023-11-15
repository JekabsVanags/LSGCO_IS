class WeeklyActivity < ApplicationRecord
  enum day: ["Pirmdiena", "Otrdiena", "Trešdiena", "Ceturtdiena", "Piektdiena", "Sestdiena", "Svētdiena"]
  enum rank: ["Mazskauti/Guntiņas", "Skauti/Gaidas", "Dižskauti/Dižgaidas", "Roveri/Lielgaidas"]

  belongs_to :unit
end
