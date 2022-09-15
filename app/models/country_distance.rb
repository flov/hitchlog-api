class CountryDistance < ApplicationRecord
  belongs_to :trip
  validates :distance, numericality: true
end
