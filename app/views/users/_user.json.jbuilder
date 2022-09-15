json.extract! user, :id, :username, :email, :gender, :lat, :lng, :about_you
json.url user_url(user, format: :json)
