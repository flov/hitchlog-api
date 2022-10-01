require "rails_helper"

RSpec.describe "/trips", type: :request do
  let(:valid_attributes) {
    {trip: {origin: {place_id: "ChIJAVkDPzdOqEcRcDteW0YgIQQ",
                     lat: 52.52000659999999,
                     lng: 13.404954,
                     city: "Berlin",
                     country: "Germany",
                     name: "Berlin, Germany",
                     country_code: "DE"},
            destination: {place_id: "ChIJuRMYfoNhsUcRoDrWe_I9JgQ",
                          lat: 53.5510846,
                          lng: 9.9936818,
                          city: "Hamburg",
                          country: "Germany",
                          country_code: "DE",
                          name: "Hamburg, Germany"},
            travelling_with: "0",
            number_of_rides: 2,
            arrival: "2000-12-12T17:12",
            departure: "2000-12-12T12:00",
            distance: 288691,
            google_duration: 11806}}
  }
  let(:invalid_attributes) { {trip: {yo: "hello"}} }
  let(:user) { create(:user) }
  let(:headers) {{
    'Accept' => 'application/json',
    'Content-Type' => 'application/json' 
  }}
  let(:auth_headers) { JWTHelpers.auth_headers(headers, user) }


  describe "GET /index" do
    context "searches with parameters" do
      it "sorts by lat/lng bounds" do
        create(:trip, from_lat: 42.5, from_lng: 12.5)
        create(:trip, from_lat: 41, from_lng: 12.5)
        get trips_url(south_lat: 42, north_lat: 43, west_lng: 12, east_lng: 13), as: :json
        expect(response.body).to include("42.5")
        expect(response.body).not_to include("41.0")
      end
    end

    it "renders a successful response" do
      create(:trip, from_city: "Kiew", to_city: "Krakow")
      get trips_url, headers: auth_headers, as: :json
      expect(response.body).to include("Kiew")
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
          post trips_url,
            params: valid_attributes, headers: auth_headers, as: :json
        }.to change(Trip, :count).by(1)
      end

      it "renders a JSON response with the new trip" do
        post trips_url,
          params: valid_attributes, headers: auth_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
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
          params: invalid_attributes, headers: auth_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {}

      xit "updates the requested trip" do
        trip = Trip.create! valid_attributes
        patch trip_url(trip),
          params: {trip: new_attributes}, headers: auth_headers, as: :json
        trip.reload
        skip("Add assertions for updated state")
      end

      xit "renders a JSON response with the trip" do
        trip = Trip.create! valid_attributes
        patch trip_url(trip),
          params: {trip: new_attributes}, headers: auth_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      xit "renders a JSON response with errors for the trip" do
        trip = Trip.create! valid_attributes
        patch trip_url(trip),
          params: {trip: invalid_attributes}, headers: auth_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    context "if logged in" do
      it "destroys the requested trip" do
        trip = create(:trip)
        expect {
          delete trip_url(trip), headers: auth_headers, as: :json
        }.to change(Trip, :count).by(-1)
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
end
