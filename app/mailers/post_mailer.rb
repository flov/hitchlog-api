class PostMailer < ApplicationMailer
  def notify_post_author(comment)
    @comment = comment
    mail(
      to: @comment.post.user.email,
      subject: "[Hitchlog] New comment on your post"
    )
  end
end
