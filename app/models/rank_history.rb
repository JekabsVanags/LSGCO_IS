class RankHistory < ApplicationRecord
  belongs_to :user, dependent: :destroy
  
  enum rank: ["MZSK/GNT","SK/G", "DZSK/DZG", "ROV/LG", "VAD", "VIEDSK/VIEDG", "CITS"]
end
