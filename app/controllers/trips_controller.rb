class TripsController < ApplicationController
  before_action :set_trip, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create create_comment update destroy]
  before_action :trip_owner?, only: %i[update destroy]

  def index
    @page = params[:page] || 1
    @trips = if params[:q].present?
      parsed_q = JSON.parse(params[:q])
      @search = Trip.includes(
        :rides,
        :user,
        :country_distances
      ).ransack(parsed_q)
      if parsed_q["sort_by_likes"]
        @search.sorts = 'likes_count desc'
      else
        @search.sorts = 'id desc'
      end
      @trips = @search
        .result(distinct: true)
        .page(@page)
        .per(12)
    else
      Trip.order(id: :desc).page(@page).per(12)
    end
  end

  def latest
    filter = {}
    if params[:photos].present?
      filter["rides_photo_present"] = true
    elsif params[:videos].present?
      filter["rides_youtube_present"] = true
    elsif params[:stories].present?
      filter["rides_story_present"] = true
    end

    @trips = Trip
      .includes(:rides)
      .ransack(filter)
      .result
      .order(Arel.sql("RANDOM()"))

    @trips = if params[:photos] == "true"
      @trips.limit(13)
    elsif params[:stories] == "true"
      @trips.limit(1)
    elsif params[:videos] == "true"
      @trips.limit(1)
    else
      Trip.order(id: :desc).limit(3)
    end
  end

  def show
  end

  # POST /trips
  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user
    update_trip

    if @trip.save
      render :show, status: :created, location: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trips/1
  def update
    update_trip
    if @trip.save && @trip.update(trip_params)
      render :show, status: :ok, location: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trips/1
  def destroy
    @trip.destroy
  end

  # POST /trips/1/comments
  def create_comment
    @comment = Comment.new(comment_params)
    @comment.trip_id = params[:id]
    @comment.user = current_user
    if @comment.save
      render "post_comments/show", status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
    notify_trip_owner_and_comment_authors(@comment)
  end

  private

  def notify_trip_owner_and_comment_authors(comment)
    # notify all comment authors who are not the trip owner and not the comment author
    comment_authors = Comment
      .where(trip_id: comment.trip_id)
      .where("user_id != #{comment.user.id}")
      .where("user_id != #{comment.trip.user.id}")
      .select("DISTINCT user_id")
      .map(&:user)

    comment_authors.each do |author|
      CommentMailer
        .notify_comment_authors(comment, author)
        .deliver_now
    end

    if comment.user != comment.trip.user
      CommentMailer
        .notify_trip_owner(comment)
        .deliver_now
    end
  end

  def update_trip
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
