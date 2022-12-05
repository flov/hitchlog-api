json.array! @users_by_gender do |user|
  json.label user[:label]
  json.value user[:value]
end
