class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable,
    :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  GENDERS = ["male", "female", "non-binary"].freeze

  has_many :trips, dependent: :destroy
  has_many :rides, through: :trips
  has_many :authentications, dependent: :destroy
  has_many :future_trips, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :username,
    presence: true,
    uniqueness: true,
    format: {with: /\A[A-Za-z\d_-]+\z/}

  def hitchhiked_countries
    trips.map { |trip| trip.country_distances.map(&:country) }.flatten.uniq.size
  end

  def hitchhiked_kms
    trips.pluck(:distance).compact.sum / 1000
  end

  def no_of_rides
    Ride.where(trip_id: trips.pluck(:id)).size
  end

  def no_of_trips
    trips.count
  end

  def no_of_stories
    rides.collect { |h| h.story }.compact.delete_if { |x| x == "" }.size
  end

  def no_of_comments
    comments.size
  end

  def average_waiting_time
    waiting_time = trips.map { |trip| trip.rides.map { |hh| hh.waiting_time } }.flatten.compact
    if waiting_time.size == 0
      nil
    else
      waiting_time.sum / waiting_time.size
    end
  end

  def average_drivers_age
    avg_drivers_age_array = rides.collect { |h| h.person&.age }.compact
    avg_drivers_age_array.sum / avg_drivers_age_array.size unless avg_drivers_age_array.size == 0
  end

  def average_speed
    avg_speed_of_trips = trips.collect(&:average_speed).map(&:to_i)
    "#{avg_speed_of_trips.sum / avg_speed_of_trips.size} kmh"
  end

  def age
    ((Date.today - date_of_birth) / 365).to_i if date_of_birth
  end

  def age_of_trips
    return unless date_of_birth

    hash = {}

    trips.map(&:age_at_trip).each do |age_at_trip|
      if hash[age_at_trip]
        hash[age_at_trip] += 1
      else
        hash[age_at_trip] = 1
      end
    end

    hash.to_a.sort
  end

  def very_good_experiences
    rides.where(rides: {experience: "very good"}).size
  end

  def good_experiences
    rides.where(rides: {experience: "good"}).size
  end

  def neutral_experiences
    rides.where(rides: {experience: "neutral"}).size
  end

  def bad_experiences
    rides.where(rides: {experience: "bad"}).size
  end

  def very_bad_experiences
    rides.where(rides: {experience: "very bad"}).size
  end

  def vehicles
    hash = {}
    rides.collect(&:vehicle).compact.reject(&:empty?).each do |vehicle|
      if hash[vehicle]
        hash[vehicle] += 1
      else
        hash[vehicle] = 1
      end
    end
    hash
  end

  private

  # Whitelist the User model attributes for sorting, except +password_digest+.
  #
  # The +full_name+ ransacker is also not included because error-prone in SQL
  # ORDER clauses and provided no additional functionality over +first_name+.
  #
  def self.ransortable_attributes(auth_object = nil)
    column_names - ["password_digest"]
  end

  # Whitelist the User model attributes for search, except +password_digest+,
  # as above. The +full_name+ ransacker below is included via +_ransackers.keys+
  #
  def self.ransackable_attributes(auth_object = nil)
    ransortable_attributes
  end
end
