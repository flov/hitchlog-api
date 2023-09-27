class RideMailer < ApplicationMailer
  def notify_about_liked_ride(ride)
    @ride = ride
    @trip = @ride.trip
    @user = @ride.trip.user
    mail(to: @user.email, subject: "[Hitchlog] Someone liked your ride!")
  end
end
