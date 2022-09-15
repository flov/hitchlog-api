class Ride < ApplicationRecord
  EXPERIENCES = ["very good",
    "good",
    "neutral",
    "bad",
    "very bad"].freeze

  VEHICLES = ["car",
    "bus",
    "truck",
    "motorcycle",
    "plane",
    "boat"].freeze

  GENDER = ["male",
    "female",
    "mixed"].freeze

  belongs_to :trip
end
