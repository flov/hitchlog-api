class OldUser < ApplicationRecord
  has_many :trips, dependent: :destroy
  has_many :rides, through: :trips
  has_many :authentications, dependent: :destroy
  has_many :future_trips, dependent: :destroy

  validates :email, presence: true
  validates :username, presence: true
end
