class UpdateMissingGeocodeInformationToTrip < ActiveRecord::Migration[7.0]
  def up
    Trip.find_each do |trip|
      TripSanitizer.new(trip).sanitize
    end
  end
end
