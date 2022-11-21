class DataMigrationTripFromToFromName < ActiveRecord::Migration[7.0]
  def up
    add_index :trips, :from_name
    Trip.find_each do |trip|
      trip.from_name = trip.from if trip.from_name.blank?
      trip.to_name = trip.to if trip.to_name.blank?
      putc "." if trip.save
    end
  end

  def down
  end
end
