class UpdateMissingGeocodeInformationToTrip < ActiveRecord::Migration[7.0]
  def up
    Trip.find_each do |trip|
      trip.update_missing_geocode_information
    end
  end
end

