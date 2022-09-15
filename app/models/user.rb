class User < ApplicationRecord
  require "securerandom"

  has_secure_password

  GENDERS = ["male", "female", "non-binary"].freeze

  has_many :trips, dependent: :destroy
  has_many :rides, through: :trips
  has_many :authentications, dependent: :destroy
  has_many :future_trips, dependent: :destroy

  validates :email, presence: true
  validates :username, presence: true
end
