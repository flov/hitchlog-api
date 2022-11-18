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

  belongs_to :trip, counter_cache: true
  has_many :likes

  validates_inclusion_of :experience, in: EXPERIENCES
  validates_inclusion_of :vehicle, in: VEHICLES, allow_blank: true
  validates_inclusion_of :gender, in: GENDER, allow_blank: true
  validates :youtube, length: {is: 11},
    format: {with: /\A[a-zA-Z0-9\-_]+\z/, message: "Allowed symbols: a-z, A-Z, 0-9, -, and _"}, allow_blank: true

  scope :very_good_experiences, -> { where(experience: "very good") }
  scope :good_experiences, -> { where(experience: "good") }
  scope :neutral_experiences, -> { where(experience: "neutral") }
  scope :bad_experiences, -> { where(experience: "bad") }
  scope :very_bad_experiences, -> { where(experience: "very bad") }

  acts_as_taggable_on :tags

  mount_uploader :photo, PhotoUploader

  def liked_by?(user)
    return false if user.nil?
    !!self.likes.find_by(user_id: user.id)
  end
end
