class RidesController < ApplicationController
  before_action :set_ride, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[like create update destroy]
  before_action :prove_ownership, only: %i[update destroy]

  # GET /rides
  # GET /rides.json
  def index
    @rides = Ride.limit(10)
  end

  # PATCH/PUT /rides/1.json
  def update
    if @ride.update(ride_params)
      render :show, status: :ok, location: @ride
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rides/1.json
  def destroy
    @ride.destroy
  end

  # PUT /rides/1/like.json
  def like
    @ride = Ride.find(params[:id])
    @like = @ride.likes.build(user: current_user)
    @ride.trip.update(likes_count: @ride.trip.likes_count + 1)
    if @like.save
      render :show, status: :created, location: @trip
    else
      render json: @like.errors.messages.values.flatten, status: :unprocessable_entity
    end
  end

  private

  def prove_ownership
    if @ride.trip.user != current_user
      render json: {errors: "You are not authorized"}, status: :forbidden
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_ride
    @ride = Ride.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def ride_params
    params.permit(
      :title,
      :photo_cache,
      :photo_caption,
      :photo,
      :story,
      :waiting_time,
      :trip_id,
      :tag_list,
      :duration,
      :number,
      :experience,
      :vehicle,
      :youtube,
      :gender
    )
  end
end
