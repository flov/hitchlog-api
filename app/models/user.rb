class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :confirmable,
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
    hash = {}
    trips.includes(:country_distances).map(&:country_distances).flatten.each do |cd|
      if hash[cd.country_code]
        hash[cd.country_code] += cd.distance
      else
        hash[cd.country_code] = cd.distance
      end
    end
    hash
  end

  def to_param
    username.downcase
  end

  def md5_email
    Digest::MD5.hexdigest(email)
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
    waiting_time = User.includes(:trips).includes(:rides).where(username: username).average(:waiting_time)
    return nil if waiting_time == 0 || waiting_time.nil?
    waiting_time.round
  end

  def average_drivers_age
    avg_drivers_age_array = rides.collect { |h| h.person&.age }.compact
    avg_drivers_age_array.sum / avg_drivers_age_array.size unless avg_drivers_age_array.size == 0
  end

  def average_speed
    avg_speed_of_trips = trips.collect(&:average_speed).map(&:to_i)
    return if avg_speed_of_trips.size == 0
    "#{avg_speed_of_trips.sum / avg_speed_of_trips.size} kmh"
  end

  def age
    ((Date.today - date_of_birth) / 365).to_i if date_of_birth
  end

  def to_geomap
    hash = {"distances" => {}, "trip_count" => {}}
    trips.flat_map(&:country_distances).each do |cd|
      if hash["distances"][Countries.name_to_code[cd.country]]
        hash["distances"][Countries.name_to_code[cd.country]] += cd.distance / 1000
        hash["trip_count"][Countries.name_to_code[cd.country]] += 1
      else
        hash["distances"][Countries.name_to_code[cd.country]] = cd.distance / 1000
        hash["trip_count"][Countries.name_to_code[cd.country]] = 1
      end
    end
    hash
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

  def genders
    rides.map(&:gender).reject(&:blank?)
  end

  def genders_in_percentage
    hash = {}
    genders.uniq.each do |gender|
      hash[gender] = (genders.count { |gen| gen == gender }.to_f / genders.size).round(2)
    end
    hash
  end

  def self.confirm_by_token(confirmation_token)
    if confirmation_token.blank?
      user = new
      user.errors.add(:confirmation_token, :blank)
      return user
    end
    user = User.find_by(confirmation_token: confirmation_token)
    if user
      user.confirm
    else
      user = new
      errors.add(:confirmation_token, :invalid)
    end
    user
  end

  def to_s
    username.capitalize
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
