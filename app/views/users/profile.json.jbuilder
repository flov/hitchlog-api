json.id @user.id
json.username @user.username
json.gender @user.gender
json.about_you @user.about_you
json.languages @user.languages
json.hitchhiked_countries @user.hitchhiked_countries
json.hitchhiked_kms @user.hitchhiked_kms
json.no_of_rides @user.no_of_rides
json.no_of_trips @user.no_of_trips
json.created_at @user.created_at
json.cs_user @user.cs_user
json.trustroots @user.trustroots
json.no_of_stories @user.no_of_stories
json.be_welcome_user @user.be_welcome_user 
json.no_of_comments @user.no_of_comments
json.average_speed @user.average_speed
json.average_waiting_time @user.average_waiting_time
json.travelling_with do
  json.alone @user.trips.alone.size
  json.in_pairs @user.trips.in_pairs.size
  json.with_three @user.trips.with_three.size
  json.with_four @user.trips.with_four.size
end
json.experiences do
  json.very_good_experiences @user.very_good_experiences
  json.good_experiences @user.good_experiences
  json.neutral_experiences @user.neutral_experiences
  json.bad_experiences @user.bad_experiences
  json.very_bad_experiences @user.very_bad_experiences
end
json.vehicles @user.vehicles
json.age_of_trips @user.age_of_trips