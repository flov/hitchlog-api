namespace :location do
  desc "data migration from trip `from`, `to` to location"
  task migrate: :environment do
    Trip.where(origin_id: nil).find_each do |trip|
      trip.origin = Location.create(
        city: trip.from_city,
        country: trip.from_country,
        country_code: trip.from_country_code,
        lat: trip.from_lat,
        lng: trip.from_lng
      )
      trip.destination = Location.create(
        city: trip.to_city,
        country: trip.to_country,
        country_code: trip.to_country_code,
        lat: trip.to_lat,
        lng: trip.to_lng
      )
      t = trip
      trip.save
    end
  end
end
