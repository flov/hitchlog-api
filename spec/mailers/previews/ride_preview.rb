# Preview all emails at http://localhost:3000/rails/mailers/ride
class RidePreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/ride/notify_about_liked_ride
  def notify_about_liked_ride_with_story
    RideMailer.notify_about_liked_ride(Ride.first)
  end

  def notify_about_liked_ride_without_story(*args)
    RideMailer.notify_about_liked_ride(Ride.find(46602))
  end
end
