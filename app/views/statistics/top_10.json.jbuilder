json.array! @top_10 do |user|
  json.username user[:username]
  json.total_distance user[:total_distance]
  json.gender user[:gender]
end
