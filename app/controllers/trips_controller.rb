class TripsController < ApplicationController
  before_action :set_trip, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :trip_owner?, only: %i[update destroy]

  def index
    @page = params[:page] || 1
    @trips = if params[:q].present?
      @search = Trip.includes(:rides).ransack(JSON.parse(params[:q]))
      @trips = @search.result(distinct: true).order(created_at: :desc).page(@page).per(12)
    else
      Trip.order(id: :desc).page(@page).per(12)
    end
  end

  def show
  end

  # POST /trips
  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user
    # adds the origin and destination to the trip
    if origin_params["origin"] && destination_params["destination"]
      origin_params["origin"].each { |k, v| @trip.send("from_#{k}=", v) }
      destination_params["destination"].each { |k, v| @trip.send("to_#{k}=", v) }
    end
    if country_distances_params["trip"]["country_distances"]
      @trip.country_distances.build(
        country_distances_params["trip"]["country_distances"]
      )
    end

    if @trip.save
      render :show, status: :created, location: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trips/1
  def update
    if @trip.update(trip_params)
      render :show, status: :ok, location: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trips/1
  def destroy
    @trip.destroy
  end

  private

  def trip_owner?
    render json: {error: "not authorized"}, status: :unauthorized if @trip.user != current_user
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_trip
    @trip = Trip.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def trip_params
    params.require(:trip).permit(
      :number_of_rides,
      :arrival,
      :departure,
      :google_duration,
      :distance,
      :travelling_with
    )
  end

  def country_distances_params
    params.permit(trip: [country_distances: [:country, :country_code, :distance]])
  end

  def origin_params
    params.require(:trip).permit(
      origin: [:place_id, :lat, :lng, :city, :country, :name, :country_code]
    )
  end

  def destination_params
    params.require(:trip).permit(
      destination: [:place_id, :lat, :lng, :city, :country, :name, :country_code]
    )
  end

  def search_params
    params.permit( :from_lat_gt, :from_lat_lt, :from_lng_gt, :from_lng_lt)
  end
end
