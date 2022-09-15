class FutureTrip < ActiveRecord::Base
  belongs_to :user
  validates :from, presence: true
  validates :to, presence: true
  validates :departure, presence: true
end
