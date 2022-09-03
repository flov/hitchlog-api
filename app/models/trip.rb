class Trip < ApplicationRecord
  has_many :rides, dependent: :destroy
  has_many :country_distances, dependent: :destroy
  has_many :comments, dependent: :destroy

  belongs_to :origin, class_name: 'Location', optional: true
  belongs_to :destination, class_name: 'Location', optional: true
end
