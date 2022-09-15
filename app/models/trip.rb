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

  attr_accessor :number_of_rides

  before_create do
    # build as many rides on top of the trip as needed
    number_of_rides.to_i.times { |i| rides.build }
  end
end
