json.array! @age_for_trips do |hash|
  json.age hash[:age].to_i
  json.trips_count hash[:trips_count]
end
