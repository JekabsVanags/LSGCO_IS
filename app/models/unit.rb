class Unit < ApplicationRecord
  validates :city, :number, :legal_adress, :bank_account, presence: :true

  has_many :users, :foreign_key => 'unit_id'
  has_many :events
  has_many :invites
end
