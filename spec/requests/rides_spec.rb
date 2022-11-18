require "rails_helper"

RSpec.describe "/rides", type: :request do
  let(:valid_attributes) {
    {
      ride: {
        id: 7321,
        vehicle: "bus",
        waiting_time: "13",
        story: "Took the Bemo out of town",
        title: "Hello ",
        experience: "very good"
      }
    }
  }
  let(:user) { create(:confirmed_user) }
  let(:trip) { create(:trip, user: user) }
  let(:ride) { create(:ride, trip: trip) }
  let(:valid_headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
  }
  let(:auth_headers) { JWTHelpers.auth_headers(valid_headers, user) }

  let(:invalid_attributes) {
    {experience: "non-existant"}
  }

  describe "GET /index" do
    it "renders a successful response" do
      ride
      get rides_url, headers: valid_headers, as: :json
      expect(response).to be_successful
      expect(response.body).to include('"already_liked":false')
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          experience: "bad",
          tag_list: "first tag, second tag"
        }
      }

      it "updates the requested ride" do
        patch ride_url(ride),
          params: new_attributes, headers: auth_headers, as: :json
        ride.reload
        expect(ride.experience).to eq("bad")
        expect(ride.tag_list).to eq(["first tag", "second tag"])
      end

      it "renders a JSON response with the ride" do
        patch ride_url(ride),
          params: new_attributes, headers: auth_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the ride" do
        patch ride_url(ride),
          params: invalid_attributes, headers: auth_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    context "logged in" do
      context "as the owner" do
        it "destroys the requested ride" do
          ride
          expect {
            delete ride_url(ride), headers: auth_headers, as: :json
          }.to change(Ride, :count).by(-1)
        end
      end

      context "as a different user" do
        it "does not destroy the requested ride" do
          ride
          expect {
            delete ride_url(ride), headers: JWTHelpers.auth_headers(valid_headers, create(:confirmed_user)), as: :json
          }.to change(Ride, :count).by(0)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context "logged out" do
      it "does not destroy the requested ride" do
        ride
        expect {
          delete ride_url(ride), headers: valid_headers, as: :json
        }.to change(Ride, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /like" do
    context "not logged in" do
      it "returns unauthorized" do
        put like_ride_url(ride.id), as: :json, headers: valid_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context "logged in" do
      context "user has not liked the ride" do
        it "creates a new like" do
          expect {
            put like_ride_url(ride.id), headers: auth_headers, as: :json
          }.to change(Like, :count).by(1)
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(response.body).to include('"already_liked":true')
        end
      end
      context "user has already liked the ride" do
        it "does not create a new like" do
          ride.likes.create(user: user)
          expect {
            put like_ride_url(ride.id), headers: auth_headers, as: :json
          }.to change(Like, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("You already liked this Ride")
        end
      end
    end
  end

  describe "#liked_by?" do
    it "returns true if the trip is liked by the user" do
      like = FactoryBot.create(:like, ride: ride)
      expect(ride.liked_by?(like.user)).to eq(true)
    end
  end
end
