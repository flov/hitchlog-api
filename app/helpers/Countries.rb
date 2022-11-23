class Countries
  attr_reader :code_to_name, :name_to_code

  include Singleton

  class << self
    delegate :code_to_name, to: :instance
    delegate :name_to_code, to: :instance
  end

  def initialize
    @code_to_name = YAML.load_file(Rails.root.join("config/country_code_to_name.yml"))
    @name_to_code = YAML.load_file(Rails.root.join("config/country_name_to_code.yml"))
  end

  private

  # used to initially get the latitutde and longitude of the country
  def geocode_countries
    code_to_name.keys.each do |code|
      search = Geocoder.search(code_to_name[code]).first
      if search
        code_to_name[code] = {
          name: code_to_name[code],
          lat: search.latitude,
          lng: search.longitude
        }
        putc '.'
      end
    end
  end
end
