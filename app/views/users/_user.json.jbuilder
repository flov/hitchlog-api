json.extract! user, :id, :username, :email, :gender, :about_you, :languages
json.url user_url(user, format: :json)
