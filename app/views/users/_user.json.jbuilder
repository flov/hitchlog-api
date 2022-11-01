json.id user.id
json.md5_email user.md5_email
json.username user.username
json.email user.email
json.gender user.gender
json.about_you user.about_you
json.languages user.languages
json.hitchhiked_kms user.hitchhiked_kms
json.number_of_trips user.trips.size
json.number_of_rides user.rides.size
json.number_of_stories user.no_of_stories
json.created_at user.created_at.strftime("%d %b %Y")
json.age user.age
json.cs_user user.cs_user
json.be_welcome_user user.be_welcome_user
json.trustroots user.trustroots
json.location do
  json.lat user.lat
  json.lng user.lng
  json.formatted_address user.formatted_address
  json.city user.city
  json.country user.country
  json.country_code user.country_code
end
