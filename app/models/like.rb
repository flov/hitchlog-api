class Like < ApplicationRecord
  belongs_to :user
  belongs_to :ride, counter_cache: true
  validates :user_id, uniqueness: { scope: :ride_id }
end
