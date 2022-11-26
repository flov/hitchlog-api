class StatisticsController < ApplicationController
  def top_10
    @top_10 = User.top_10
  end

  def age_for_trips
    @age_for_trips = Trip.age_for_trips
  end
end
