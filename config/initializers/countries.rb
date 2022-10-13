module Countries
  def self.[](key)
    @countries ||= YAML.load(File.open("#{Rails.root}/config/countries.yml"))
    @countries[key]
  end

  def self.[]=(key, value)
    @countries[key.to_sym] = value
  end
end
