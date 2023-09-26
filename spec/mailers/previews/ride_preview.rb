# Preview all emails at http://localhost:3000/rails/mailers/user
class RidePreview < ActionMailer::Preview
  def notify_about_liked_ride
    ride = FactoryBot.create(:ride)
    RideMailer.notify_about_liked_ride(ride)
  end
end
