json.id trip.id
json.to_param trip.to_param
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
json.country_distances do
  json.array! trip.country_distances do |country|
    json.country country.country
    json.country_code country.country_code
    json.distance country.distance
  end
end
json.user do
  json.username trip.user.username
  json.gender trip.user.gender
  json.md5_email trip.user.md5_email
end
json.origin do
  json.country_code trip.from_country_code
  json.country trip.from_country
  json.city trip.from_city
  json.lat trip.from_lat
  json.lng trip.from_lng
  json.place_id trip.from_place_id
  json.name trip.from_name
  json.sanitized_address trip.sanitize_address("from")
end
json.destination do
  json.country_code trip.to_country_code
  json.country trip.to_country
  json.city trip.to_city
  json.lat trip.to_lat
  json.lng trip.to_lng
  json.place_id trip.to_place_id
  json.name trip.to_name
  json.sanitized_address trip.sanitize_address("to")
end
json.rides do
  json.array! trip.rides.order(id: :asc), partial: "rides/ride", as: :ride
end
json.comments do
  json.array! trip.comments.order(id: :asc) do |comment|
    json.partial! "post_comments/post_comment", comment: comment
  end
end
