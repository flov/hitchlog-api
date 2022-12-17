require "rails_helper"

RSpec.describe "/trips", type: :request do
  let(:valid_attributes) {
    {"trip" =>
      {"origin" =>
        {"place_id" => "ChIJtQc1pJmfagwRATBZlraFkIo",
         "lat" => 28.0467575,
         "lng" => -16.5725303,
         "city" => "",
         "country" => "Spain",
         "country_code" => "ES",
         "formatted_address" =>
          "38610, Santa Cruz de Tenerife, Spain"},
       "destination" =>
        {"place_id" => "ChIJeY5GfiyYagwRkkcCvPRAAyY",
         "lat" => 28.0489062,
         "lng" => -16.7115979,
         "city" => "Los Cristianos",
         "country" => "Spain",
         "country_code" => "ES",
         "formatted_address" =>
          "38650 Los Cristianos, Santa Cruz de Tenerife, Spain"},
       "country_distances" =>
        [{"country" => "Spain",
          "country_code" => "ES",
          "distance" => 15861}],
       "from_name" => "teneirfe airport",
       "to_name" => "los christianos",
       "travelling_with" => "0",
       "number_of_rides" => 1,
       "arrival" => "1999-12-12T17:12",
       "departure" => "1999-12-12T12:00",
       "totalDistance" => 15861,
       "googleDuration" => 743,
       "photo" => ""}}
  }
  let(:invalid_attributes) { {trip: {yo: "hello"}} }
  let(:user) { create(:confirmed_user) }
  let(:user_1) { create(:confirmed_user, id: 2) }
  let(:user_2) { create(:confirmed_user, id: 3) }
  let(:headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
  }
  let(:trip) { create(:trip, user: user) }
  let(:user_auth_headers) { JWTHelpers.auth_headers(headers, user) }
  let(:user_1_auth_headers) { JWTHelpers.auth_headers(headers, user_1) }
  let(:user_2_auth_headers) { JWTHelpers.auth_headers(headers, user_2) }

  describe "GET /index" do
    it "renders a successful response" do
      create(:trip, from_city: "Kiew", to_city: "Krakow")
      get trips_url, headers: headers, as: :json
      expect(response.body).to include("Kiew")
    end

    it "sorts by likes_count" do
      create(:trip, from_city: 'Berlin', likes_count: 1)
      create(:trip, from_city: 'Lisbon', likes_count: 0)
      create(:trip, from_city: 'Warsaw', likes_count: 2)
      get '/trips?q=%7B"rides_story_present"%3Afalse%7D&sort_by_likes=true', headers: headers
      expect(JSON.parse(response.body)['trips'].first['origin']['city']).to eq('Warsaw')
      expect(JSON.parse(response.body)['trips'].last['origin']['city']).to eq('Lisbon')
    end

    it "sorts by lat/lng bounds" do
      create(:trip, from_lat: 42.5, from_lng: 12.5)
      create(:trip, from_lat: 41, from_lng: 12.5)
      get "/trips?q=%7B%22from_lat_lt%22%3A43%2C%22from_lat_gt%22%3A42%2C%22from_lng_gt%22%3A12%2C%22from_lng_lt%22%3A13%7D", as: :json
      expect(response.body).to include("42.5")
      expect(response.body).not_to include("41.0")
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      trip = create(:trip)
      get trip_url(trip), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Trip" do
        expect {
          post trips_url, params: valid_attributes, headers: user_auth_headers, as: :json
        }.to change(Trip, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(Trip.last.rides.count).to eq(1)
        expect(Trip.last.rides.first.number).to eq(1)
      end

      it "renders a JSON response with the new trip" do
        post trips_url, params: valid_attributes, headers: user_auth_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(JSON.parse(response.body)["origin"]["name"]).to eq("teneirfe airport")
        expect(Trip.last.from_name).to eq("teneirfe airport")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Trip" do
        expect {
          post trips_url,
            params: invalid_attributes, as: :json
        }.to change(Trip, :count).by(0)
      end

      it "renders a JSON response with errors for the new trip" do
        post trips_url,
          params: invalid_attributes, headers: user_auth_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { {travelling_with: 2} }

      it "updates the requested trip" do
        trip
        patch trip_url(trip),
          params: {trip: new_attributes}, headers: user_auth_headers, as: :json
        trip.reload
        expect(trip.travelling_with).to eq(2)
      end

      it "renders a JSON response with the trip" do
        trip
        patch trip_url(trip),
          params: {trip: new_attributes}, headers: user_auth_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to include("2")
      end
    end
  end

  describe "DELETE /destroy" do
    context "if logged in" do
      context "if owner" do
        it "destroys the requested trip" do
          trip
          expect {
            delete trip_url(trip), headers: user_auth_headers, as: :json
          }.to change(Trip, :count).by(-1)
        end
      end

      context "if not owner" do
        it "does not destroy the requested trip" do
          trip = create(:trip)
          expect {
            delete trip_url(trip), headers: user_auth_headers, as: :json
          }.to change(Trip, :count).by(0)
        end
      end
    end

    context "if not logged in" do
      it "does not destroy the requested trip" do
        trip = create(:trip)
        expect {
          delete trip_url(trip), as: :json
        }.to change(Trip, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /latest" do
    let(:test_photo) {
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, "spec", "support", "images", "thumb.png")
      )
    }

    describe "without params" do
      it "returns the latest three trips" do
        create(:trip, from_city: "Kiew")
        create(:trip, from_city: "Berlin")
        create(:trip, from_city: "Hamburg")
        create(:trip, from_city: "Munich")
        get latest_trips_url, headers: user_auth_headers, as: :json
        expect(response.body).to_not include("Kiew")
        expect(response.body).to include("Berlin")
        expect(response.body).to include("Hamburg")
        expect(response.body).to include("Munich")
      end
    end

    describe "with params[:videos] = true" do
      it "returns the latest trip with a video" do
        trip1 = build(:trip, from_city: "Kiew")
        trip1.rides.build(youtube: "00000000001")
        trip1.save
        get latest_trips_url(videos: true), headers: headers, as: :json
        expect(response.body).to include("Kiew")
        expect(response.body).to include('"likes":0')
        expect(response.body).to include('"already_liked":false')
      end
    end

    describe "with params[:stories] = true" do
      it "returns the latest trips with stories" do
        trip = build(:trip, user: user)
        trip.rides.build(story: "hello")
        trip.save
        get latest_trips_url(stories: true), headers: headers, as: :json
        expect(response).to be_successful
        expect(response.body).to include("hello")
      end
    end

    describe "with params[:photos] == true" do
      it "returns only trips with photos" do
        trip = build(:trip, from_city: "hey guys", user: user)
        trip.rides.build(photo: test_photo)
        trip.save
        create(:trip, from_city: "Atlantis")
        get "/trips/latest?photos=true", as: :json
        expect(response.body).to include("hey guys")
        expect(response.body).not_to include("Atlantis")
      end
    end
  end

  describe "POST /create_comment" do
    context "when not logged in" do
      it "does not create a comment" do
        expect {
          post create_comment_trip_url(trip.id),
            params: {comment: {body: "hello"}},
            as: :json
        }.to change(Comment, :count).by(0)
      end
    end

    context "when logged in" do
      context "with valid parameters" do
        it "renders a JSON response with the new comment" do
          post create_comment_trip_url(trip.id),
            params: {comment: {body: "hello"}},
            headers: user_auth_headers,
            as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(response.body).to include("hello")
        end

        it "creates a new comment" do
          expect {
            post create_comment_trip_url(trip.id),
              params: {comment: {body: "hello"}}, headers: user_auth_headers, as: :json
          }.to change(Comment, :count).by(1)
          expect(response).to have_http_status(:created)
        end

        context "another user comments on a trip" do
          it "notifies the owner that someone commented on their trip" do
            expect(CommentMailer).to receive(:notify_trip_owner)
              .and_call_original
            post create_comment_trip_url(trip.id),
              params: {comment: {body: "hello"}},
              headers: user_1_auth_headers,
              as: :json
          end
        end

        context "user 1 has already commented on the trip and user 2 comments" do
          it "notifies user 1 and not user 2 and the author of the trip" do
            user_1
            user_2
            trip.comments.create(body: "hello", user: user_1)
            expect(CommentMailer).to receive(:notify_trip_owner)
              .and_call_original
            expect(CommentMailer).to receive(:notify_comment_authors)
              .once
              .and_call_original
            post create_comment_trip_url(trip.id),
              params: {comment: {body: "yoyoyo"}},
              headers: user_2_auth_headers,
              as: :json
          end
        end

        it "notifies everyone who commented on the trip except for the comment author" do
          post create_comment_trip_url(trip.id),
            params: {comment: {body: "hello"}}, headers: user_auth_headers, as: :json
        end
      end

      context "with invalid parameters" do
        it "does not create a new comment and returns 422" do
          expect {
            post create_comment_trip_url(trip.id),
              params: {comment: {body: ""}}, headers: user_auth_headers, as: :json
          }.to change(Comment, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
