class RankHistory < ApplicationRecord
  belongs_to :user, dependent: :destroy
  validates :date_begin, :rank, presence: true

  enum rank: ['MZSK/GNT', 'SK/G', 'DZSK/DZG', 'ROV/LG', 'VAD', 'VIEDSK/VIEDG', 'CITS']
end
