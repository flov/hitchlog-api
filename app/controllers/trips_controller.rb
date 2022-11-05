class TripsController < ApplicationController
  before_action :set_trip, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :trip_owner?, only: %i[update destroy]

  def index
    @page = params[:page] || 1
    @trips = if params[:q].present?
      @search = Trip.includes(
        :rides,
        :user,
        :country_distances
      ).ransack(JSON.parse(params[:q]))
      @trips = @search
        .result(distinct: true)
        .order(created_at: :desc)
        .page(@page)
        .per(12)
    else
      Trip.order(id: :desc).page(@page).per(12)
    end
  end

  def latest
    if params[:photos] == "true"
      @trips = Trip
        .includes(:rides)
        .ransack(rides_photo_present: true)
        .result(distinct: true)
        .order(id: :desc)
        .limit(8)
    elsif params[:stories] == "true"
      @trips = Trip
        .includes(:rides)
        .ransack(rides_story_present: true)
        .result
        .order(id: :desc)
        .limit(3)
    elsif params[:videos] == "true"
      @trips = Trip
        .includes(:rides)
        .ransack(rides_youtube_present: true)
        .result
        .order(id: :desc)
        .limit(1)
    else
      @trips = Trip.order(id: :desc).limit(3)
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

  def create_comment
    @comment = Comment.new(comment_params)
    @comment.trip_id = params[:id]
    @comment.user = current_user
    if @comment.save
      render 'post_comments/show', status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def notify_trip_owner_and_comment_authors(comment)
    # TODO...
  end

  def trip_owner?
    if @trip.user != current_user
      render json: {
        error: "not authorized"
      }, status: :unauthorized
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_trip
    @trip = Trip.find(params[:id].split("-").last)
  end

  # Only allow a list of trusted parameters through.
  def trip_params
    params.require(:trip).permit(
      :number_of_rides,
      :from_name,
      :to_name,
      :arrival,
      :departure,
      :google_duration,
      :distance,
      :travelling_with
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def country_distances_params
    params.permit(trip: [country_distances: [:country, :country_code, :distance]])
  end

  def location
    [:formatted_address, :place_id, :lat, :lng, :city, :country, :name, :country_code]
  end

  def origin_params
    params.require(:trip).permit(
      :from_name,
      origin: location
    )
  end

  def destination_params
    params.require(:trip).permit(
      :to_name,
      destination: location
    )
  end

  def search_params
    params.permit(:from_lat_gt, :from_lat_lt, :from_lng_gt, :from_lng_lt)
  end
end
