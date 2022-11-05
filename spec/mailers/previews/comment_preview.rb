# Preview all emails at http://localhost:3000/rails/mailers/comment
class CommentPreview < ActionMailer::Preview
  def notify_comment_authors
    CommentMailer.notify_comment_authors(comment, author)
  end

  def notify_trip_owner
    CommentMailer.notify_trip_owner(comment)
  end

  private

  def comment
    @comment ||= Comment.first
  end

  def author
    @author ||= User.first
  end
end

