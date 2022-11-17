class Like < ApplicationRecord
  belongs_to :user
  belongs_to :ride
  validates :user_id, uniqueness: { scope: :ride_id }
end
