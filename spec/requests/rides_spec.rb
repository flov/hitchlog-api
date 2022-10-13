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
  let(:user) { create(:user) }
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
          params: {ride: new_attributes}, headers: auth_headers, as: :json
        ride.reload
        expect(ride.experience).to eq("bad")
        expect(ride.tag_list).to eq(["first tag", "second tag"])
      end

      it "renders a JSON response with the ride" do
        patch ride_url(ride),
          params: {ride: new_attributes}, headers: auth_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the ride" do
        patch ride_url(ride),
          params: {ride: invalid_attributes}, headers: auth_headers, as: :json
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
            delete ride_url(ride), headers: JWTHelpers.auth_headers(valid_headers, create(:user)), as: :json
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
end
