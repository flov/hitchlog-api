class TripSanitizer
  attr_reader :trip

  def initialize(trip)
    @trip = trip
  end

  def update_travelling_with
    if trip.travelling_with.blank?
      trip.update_column(:travelling_with, 1)
      puts "Updated travelling_with for #{id}"
    end
  end

  def find_missing_attributes
    ["from", "to"].each do |direction|
      missing_information = []
      ["formatted_address", "lat", "lng", "city", "country", "name", "country_code"]
        .each do |attribute|
        missing_information << attribute if trip.send("#{direction}_#{attribute}").blank?
        if attribute == "formatted_address"
          if trip.send("#{direction}_#{attribute}") == "unknown"
            missing_information << "formatted_address"
          end
        end
      end
      if missing_information.any?
        puts "Missing information for #{id} #{trip.sanitize_address(direction)}: #{missing_information.join(", ")}" if Rails.env != "test"
        geocode = Geocoder.search(trip.sanitize_address(direction)).first
        if geocode
          missing_information.each do |missing_attribute|
            if missing_attribute == "formatted_address"
              trip.update_column("#{direction}_formatted_address", geocode.address)
            elsif missing_attribute == "name"
              trip.update_column("#{direction}_name", geocode.address)
            elsif missing_attribute == "lat"
              trip.update_column("#{direction}_lat", geocode.latitude)
            elsif missing_attribute == "lng"
              trip.update_column("#{direction}_lng", geocode.longitude)
            else
              trip.update_column("#{direction}_#{missing_attribute}", geocode.send(missing_attribute))
            end
          end
        else
          puts "No geocode found for #{trip.sanitize_address(direction)}"
        end
        if trip.send("#{direction}_lat").blank? || trip.send("#{direction}_lng").blank?
          puts "Missing coordinates for #{direction}"
          Geocoder.search(trip.sanitize_address(direction)).first.tap do |result|
            if result
              trip.update_column("#{direction}_lat", result.latitude)
              trip.update_column("#{direction}_lng", result.longitude)
            end
          end
        end
      end
    end
  end

  def sanitize
    find_missing_attributes
    update_travelling_with
  end
end
