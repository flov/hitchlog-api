json.extract! @comment, :body, :created_at
json.author do
  json.extract! @comment.user, :name, :username
  json.avatar_url "https://www.gravatar.com/avatar/#{@comment.user.md5_email}?s=100"
end

