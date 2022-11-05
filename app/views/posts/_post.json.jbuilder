json.extract! post, :id, :title, :body, :tag, :created_at, :updated_at, :to_param, :summary
json.author do
  json.extract! post.user, :name, :username
  json.avatar_url "https://www.gravatar.com/avatar/#{post.user.md5_email}?s=100"
end
json.comments do
  json.array! post.post_comments do |comment|
    json.partial! "post_comments/post_comment", comment: comment
  end
end
