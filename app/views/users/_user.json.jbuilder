json.id user.id
json.username user.username
json.email user.email
json.gender user.gender
json.about_you user.about_you
json.languages user.languages
json.hitchhiked_kms user.hitchhiked_kms
json.number_of_trips user.trips.size
json.number_of_rides user.rides.size
json.created_at user.created_at.strftime("%d %b %Y")
json.age user.age
json.location do
  json.name user.location
  json.country_code user.country_code
end
