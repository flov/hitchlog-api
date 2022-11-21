class MigrateCounterCacheData < ActiveRecord::Migration[7.0]
  def up
    puts "Migrating counter cache data..."
    puts "Trips:"
    Trip.find_each do |trip|
      Trip.reset_counters(trip.id, :rides)
      Trip.reset_counters(trip.id, :comments)
      putc "."
    end

    puts "Rides:"
    Ride.find_each do |ride|
      Ride.reset_counters(ride.id, :likes)
      putc "."
    end
  end
end
