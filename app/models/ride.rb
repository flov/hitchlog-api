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

  Ride::EXPERIENCES.each do |exp|
    define_singleton_method "#{exp.parameterize.underscore}_experiences_ratio" do
      ((send("#{exp.parameterize.underscore}_experiences").count.to_f / count) * 100).round(2)
    end
  end

  def liked_by?(user)
    return false if user.nil?
    !!likes.find_by(user_id: user.id)
  end

  def self.ratio_for_waiting_time_between(starts, ends)
    total_rides = where("waiting_time != ?", 0).where("waiting_time is not null").count
    return 1 if total_rides == 0
    ((where(waiting_time: starts..ends).count.to_f / total_rides) * 100).round
  end

  def self.waiting_time_statistics
    interval = 10
    array = (10..60).step(interval).map do |waiting_time|
      {
        label: "#{waiting_time - (interval - 1)}-#{waiting_time} min",
        value: Ride.ratio_for_waiting_time_between(waiting_time - (interval - 1), waiting_time)
      }
    end
    interval = 60
    array + (120..240).step(interval).map do |waiting_time|
      {
        label: "#{waiting_time - (interval - 1)}-#{waiting_time} min",
        value: Ride.ratio_for_waiting_time_between(waiting_time - (interval - 1), waiting_time)
      }
    end
  end

  def self.experiences_data
    ["very good", "good", "neutral", "bad", "very bad"].map do |exp|
      {
        label: exp,
        value: send("#{exp.parameterize.underscore}_experiences_ratio")
      }
    end
  end
end
