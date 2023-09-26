class RideMailer < ApplicationMailer
  def notify_about_liked_ride(ride)
    @ride = ride
    @user = @ride.trip.user
    mail(to: @user.email, subject: "Someone liked your ride!")
  end
end
