class Unit < ApplicationRecord
  has_many :users
  has_many :events
  has_many :invites
end
