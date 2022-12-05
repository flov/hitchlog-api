class StatisticsController < ApplicationController
  def top_10
    @top_10 = User.top_10
  end

  def age_for_trips
    @age_for_trips = Trip.age_for_trips
  end

  def waiting_time
    @waiting_time = Ride.waiting_time_statistics
  end

  def users_by_gender
    @users_by_gender = User.users_by_gender
  end
end
