json.id @user.id
json.md5_email @user.md5_email
json.age @user.age
json.username @user.username
json.gender @user.gender
json.about_you @user.about_you
json.languages @user.languages
json.hitchhiked_countries @user.hitchhiked_countries
json.hitchhiked_kms @user.hitchhiked_kms
json.number_of_rides @user.no_of_rides
json.number_of_trips @user.no_of_trips
json.number_of_stories @user.no_of_stories
json.number_of_comments @user.no_of_comments
json.created_at @user.created_at
json.cs_user @user.cs_user
json.trustroots @user.trustroots
json.be_welcome_user @user.be_welcome_user
json.average_speed @user.average_speed
json.average_waiting_time @user.average_waiting_time
json.location do
  json.lat @user.lat
  json.lng @user.lng
  json.formatted_address @user.formatted_address
  json.city @user.city
  json.country @user.country
  json.country_code @user.country_code
end
json.travelling_with do
  json.alone @user.trips.alone.size
  json.in_pairs @user.trips.in_pairs.size
  json.with_three @user.trips.with_three.size
  json.with_four @user.trips.with_four.size
end
json.experiences do
  json.very_good @user.very_good_experiences if @user.very_good_experiences > 0
  json.good @user.good_experiences if @user.good_experiences > 0
  json.neutral @user.neutral_experiences if @user.neutral_experiences > 0
  json.bad @user.bad_experiences if @user.bad_experiences != 0
  json.very_bad @user.very_bad_experiences if @user.very_bad_experiences != 0
end
json.vehicles @user.vehicles
json.age_of_trips @user.age_of_trips
