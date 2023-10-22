class Invite < ApplicationRecord
  belongs_to :unit
  belongs_to :event

  enum rank: ['MZSK/GNT', 'SK/G', 'DZSK/DZG', 'ROV/LG', 'VAD', 'VIEDSK/VIEDG', 'CITS']
end
