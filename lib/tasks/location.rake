namespace :location do
  desc "data migration from trip `from`, `to` to location"
  task :migrate => :environment do
    Trip.where(origin_id: nil).limit(10) do |trip|
      trip.origin = Location.create(
        city: trip.from_city,
        country: trip.from_country,
        country_code: trip.from_country_code,
        lat: trip.from_lat,
        lng: trip.from_lng)
      trip.save
    end
  end
end
