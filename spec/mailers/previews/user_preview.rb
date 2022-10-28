# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def send_message
    UserMailer.send_message(user, another_user, "hello, what's up?")
  end

  private

  def user
    @user ||= FactoryBot.build(:confirmed_user)
  end

  def another_user
    @another_user ||= FactoryBot.build(:confirmed_user)
  end
end
