class RidesController < ApplicationController
  before_action :set_ride, only: %i[show update destroy]

  # GET /rides
  # GET /rides.json
  def index
    @rides = Ride.limit(10)
  end

  # GET /rides/1
  # GET /rides/1.json
  def show
  end

  # POST /rides
  # POST /rides.json
  def create
    @ride = Ride.new(ride_params)

    if @ride.save
      render :show, status: :created, location: @ride
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rides/1
  # PATCH/PUT /rides/1.json
  def update
    if @ride.update(ride_params)
      render :show, status: :ok, location: @ride
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rides/1
  # DELETE /rides/1.json
  def destroy
    @ride.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ride
    @ride = Ride.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def ride_params
    params.require(:ride).permit(:title, :story, :waiting_time, :trip_id, :duration, :number, :experience, :vehicle, :youtube, :gender)
  end
end
