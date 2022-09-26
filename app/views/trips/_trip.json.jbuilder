json.id trip.id
json.created_at trip.created_at
json.distance trip.distance
json.departure trip.departure
json.arrival trip.arrival
json.travelling_with trip.travelling_with
json.google_duration trip.google_duration
json.total_distance trip.distance
json.user_id trip.user_id
json.age_at_trip trip.age_at_trip
json.average_speed trip.average_speed
if trip.old_user
  json.user do
    json.username trip.old_user.username
    json.gender trip.old_user.gender
  end
else
  json.user do
    json.username trip.user.username
    json.gender trip.user.gender
  end
end
json.origin do
  json.country_code trip.from_country_code
  json.country trip.from_country
  json.city trip.from_city
  json.lat trip.from_lat
  json.lng trip.from_lng
  # json.place_id trip.from_place_id
end
json.destination do
  json.country_code trip.to_country_code
  json.country trip.to_country
  json.city trip.to_city
  json.lat trip.to_lat
  json.lng trip.to_lng
  # json.place_id trip.destination.place_id
end
json.rides do
  json.array! trip.rides.order(id: :asc), partial: "rides/ride", as: :ride
end
