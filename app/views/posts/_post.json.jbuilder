json.extract! post, :id, :title, :body, :tags, :created_at, :updated_at, :to_param, :summary
json.author do
  json.extract! post.user, :name, :username
  json.avatar_url "https://www.gravatar.com/avatar/#{post.user.md5_email}?s=100"
end
json.comments do
  json.array! post.post_comments do |comment|
    json.extract! comment, :body, :created_at
    json.author do
      json.extract! comment.user, :name, :username
      json.avatar_url "https://www.gravatar.com/avatar/#{comment.user.md5_email}?s=100"
    end
  end
end
