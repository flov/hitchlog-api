namespace :data do
  desc "Geocode trips with missing distance"
  task geocode_trips_with_missing_distance: :environment do
    gmaps = GoogleMapsService::Client.new(key: ENV["GOOGLE_MAPS"])
    trips = Trip.where(distance: nil)
    if trips.none?
      puts "No trips to geocode"
    else
      puts "Geocoding #{trips.count} trips without a distance"
    end
    trips.each do |trip|
      directions = gmaps.directions(
        trip.from_name, trip.to_name, mode: "driving", units: "metric"
      )
      if directions[0]
        trip.distance = directions[0][:legs][0][:distance][:value]
        trip.save
        puts "#{trip.from_name} to #{trip.to_name} is #{trip.distance}m"
      end
    end
  end

  desc "Update from to from_name"
  task migrate_trips: :environment do
    puts "hello"
    Trip.all do |trip|
      puts trip.id
      if trip.from && trip.from_name.nil?
        trip.from_name = trip.from
        trip.save
        puts "."
      end
    end
  end
end
