json.extract! post_comment, :body
json.author do
  json.extract! post_comment.user, :name, :username
  json.avatar_url "https://www.gravatar.com/avatar/#{post_comment.user.md5_email}?s=100"
end
