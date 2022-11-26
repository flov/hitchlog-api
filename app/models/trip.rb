class Trip < ApplicationRecord
  include AccurateDistanceOfTimeInWordsHelper

  has_many :rides, dependent: :destroy
  has_many :country_distances, dependent: :destroy
  has_many :comments, dependent: :destroy

  belongs_to :user

  validates :number_of_rides, numericality: true,
    presence: true, if: [proc { |trip| trip.new_record? }]
  validates :departure, presence: true
  validates :arrival, presence: true
  validates :from_lat, presence: true
  validates :from_lng, presence: true
  validates :to_lat, presence: true
  validates :to_lng, presence: true
  validates :travelling_with, presence: true

  scope :alone, -> { where(travelling_with: 0) }
  scope :in_pairs, -> { where(travelling_with: 1) }
  scope :with_three, -> { where(travelling_with: 2) }
  scope :with_four, -> { where(travelling_with: 3) }

  attr_accessor :number_of_rides

  before_create do
    # build as many rides on top of the trip as needed
    number_of_rides.to_i.times do |i|
      rides.build(number: i + 1)
    end
  end

  def to_s
    "Trip from #{sanitize_address("from")} to #{sanitize_address("to")}"
  end

  def to_param
    origin = CGI.escape(sanitize_address("from"))
    destin = CGI.escape(sanitize_address("to"))

    "hitchhiking-trip-from-#{origin}-to-#{destin}-#{id}".parameterize
  end

  def sanitize_address(direction)
    if send("#{direction}_city").present?
      send("#{direction}_city")
    elsif send("#{direction}_name").present?
      send("#{direction}_name")
    elsif send("#{direction}_formatted_address").present?
      send("#{direction}_formatted_address")
    elsif send(direction.to_s).present?
      send(direction.to_s)
    else
      ""
    end
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
    return 0 if duration == 0 || distance.nil?
    "#{((distance / 1000) / (duration / 60 / 60)).round} km/h"
  end

  def kmh
    kilometers = distance.to_f / 1000
    hour = duration / 60 / 60
    (kilometers / hour).to_i
  end

  def countries
    country_distances.map(&:country)
  end

  def center
    [(from_lat + to_lat) / 2, (from_lng + to_lng) / 2].join(",")
  end

  def add_ride
    rides.build(number: rides.size + 1)
    save
  end

  def duration
    if arrival && departure
      arrival - departure
    end
  end

  def from_coordinates
    [from_lat, from_lng].join(",")
  end

  def to_coordinates
    [to_lat, to_lng].join(",")
  end

  def self.average_age_of_hitchhikers
    array_of_ages = Trip.joins(:user).where.not(users: {date_of_birth: nil})
      .select(:id, :departure, :"users.date_of_birth")
      .map { |trip| ((trip.departure.to_date - trip.date_of_birth) / 365).to_i }
      .delete_if { |x| x < 14 || x > 70 }

    (array_of_ages.reduce(:+).to_f / array_of_ages.size).round
  end

  def self.age_for_trips
    array_of_ages = Trip.joins(:user).where.not(users: {date_of_birth: nil})
      .select(:id, :departure, :"users.date_of_birth")
      .map { |trip| ((trip.departure.to_date - trip.date_of_birth) / 365).to_i }
      .delete_if { |x| x < 14 || x > 70 }

    hash = {}
    array_of_ages.each do |age|
      if hash[age]
        hash[age] += 1
      else
        hash[age] = 1
      end
    end

    hash.sort.to_h.map do |age, trips_count|
      {age: age.to_s, trips_count: trips_count}
    end
  end
end
