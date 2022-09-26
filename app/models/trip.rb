class Trip < ApplicationRecord
  has_many :rides, dependent: :destroy
  has_many :country_distances, dependent: :destroy
  has_many :comments, dependent: :destroy

  belongs_to :user
  belongs_to :old_user, foreign_key: "user_id", optional: true
  # belongs_to :origin, class_ name: "Location", optional: true
  # belongs_to :destination, class_name: "Location", optional: true

  validates :number_of_rides, numericality: true,
    presence: true, if: [proc { |trip| trip.new_record? }]
  # validates :origin, presence: true
  # validates :destination, presence: true
  validates :departure, presence: true
  validates :arrival, presence: true
  validates :from_lat, presence: true
  validates :from_lng, presence: true
  validates :to_lat, presence: true
  validates :to_lng, presence: true
  validates :travelling_with, presence: true

  scope :alone,               -> { where(travelling_with: 0) }
  scope :in_pairs,            -> { where(travelling_with: 1) }
  scope :with_three,          -> { where(travelling_with: 2) }
  scope :with_four,           -> { where(travelling_with: 3) }

  attr_accessor :number_of_rides

  before_create do
    # build as many rides on top of the trip as needed
    number_of_rides.to_i.times { |i| rides.build }
  end

  def hitchhiked_kms
    distance / 1000
  end

  def total_waiting_time
    waiting_times = rides.map(&:waiting_time).compact
    if waiting_times.any?
      accurate_distance_of_time_in_words(waiting_times.sum.minutes)
    end
  end

  def age_at_trip
    return unless user.date_of_birth
    ((departure.to_date - user.date_of_birth) / 365).to_i
  end

  def average_speed
    return 0 if duration == 0 || distance == nil
    "#{((distance / 1000) / (duration / 60 / 60)).round} kmh"
  end

  def kmh
    kilometers = self.distance.to_f / 1000
    hour       = self.duration / 60 / 60
    (kilometers / hour).to_i
  end

  def countries
    country_distances.map(&:country)
  end

  def duration
    if arrival && departure
      arrival - departure
    end
  end
end
