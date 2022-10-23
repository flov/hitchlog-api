namespace :data do
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
