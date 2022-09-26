class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  GENDERS = ["male", "female", "non-binary"].freeze

  has_many :trips, dependent: :destroy
  has_many :rides, through: :trips
  has_many :authentications, dependent: :destroy
  has_many :future_trips, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email, presence: true
  validates :username,
    presence: true,
    uniqueness: true,
    format: {with: /\A[A-Za-z\d._-]+\z/}

  def hitchhiked_countries
    self.trips.map{|trip| trip.country_distances.map(&:country)}.flatten.uniq.size
  end

  def hitchhiked_kms
    self.trips.pluck(:distance).compact.sum/1000
  end

  def no_of_rides
    Ride.where(trip_id: self.trips.pluck(:id)).size
  end

  def no_of_trips
    self.trips.count
  end

  def no_of_stories
    self.rides.collect{|h| h.story}.compact.delete_if{|x| x == ''}.size
  end

  def no_of_comments
    self.comments.size
  end

  def average_waiting_time
    waiting_time = self.trips.map{|trip| trip.rides.map{|hh| hh.waiting_time}}.flatten.compact
    if waiting_time.size == 0
      nil
    else
      waiting_time.sum / waiting_time.size
    end
  end

  def average_drivers_age
    avg_drivers_age_array = self.rides.collect{|h| h.person.age if h.person}.compact
    avg_drivers_age_array.sum / avg_drivers_age_array.size unless avg_drivers_age_array.size == 0    
  end

  def average_speed
    avg_speed_of_trips = self.trips.collect(&:average_speed).map(&:to_i)
    "#{avg_speed_of_trips.sum / avg_speed_of_trips.size} kmh"
  end

  def age
    ((Date.today - date_of_birth) / 365).to_i if date_of_birth
  end

  def age_of_trips
    return unless date_of_birth

    hash = {}

    self.trips.map(&:age_at_trip).each do |age_at_trip|
      if hash[age_at_trip]
        hash[age_at_trip] += 1
      else
        hash[age_at_trip] = 1
      end
    end

    hash.to_a.sort
  end

  def very_good_experiences
    self.rides.where( rides: {experience: 'very good'}).size
  end

  def good_experiences
    self.rides.where( rides: {experience: 'good'}).size
  end

  def neutral_experiences
    self.rides.where( rides: {experience: 'neutral'}).size
  end

  def bad_experiences
    self.rides.where( rides: {experience: 'bad'}).size
  end

  def very_bad_experiences
    self.rides.where( rides: {experience: 'very bad'}).size
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
end
