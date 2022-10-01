require "rails_helper"

RSpec.describe "/rides", type: :request do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # RidesController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Ride.create! valid_attributes
      get rides_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      ride = Ride.create! valid_attributes
      get ride_url(ride), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Ride" do
        expect {
          post rides_url,
            params: {ride: valid_attributes}, headers: valid_headers, as: :json
        }.to change(Ride, :count).by(1)
      end

      it "renders a JSON response with the new ride" do
        post rides_url,
          params: {ride: valid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Ride" do
        expect {
          post rides_url,
            params: {ride: invalid_attributes}, as: :json
        }.to change(Ride, :count).by(0)
      end

      it "renders a JSON response with errors for the new ride" do
        post rides_url,
          params: {ride: invalid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested ride" do
        ride = Ride.create! valid_attributes
        patch ride_url(ride),
          params: {ride: new_attributes}, headers: valid_headers, as: :json
        ride.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the ride" do
        ride = Ride.create! valid_attributes
        patch ride_url(ride),
          params: {ride: new_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the ride" do
        ride = Ride.create! valid_attributes
        patch ride_url(ride),
          params: {ride: invalid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested ride" do
      ride = Ride.create! valid_attributes
      expect {
        delete ride_url(ride), headers: valid_headers, as: :json
      }.to change(Ride, :count).by(-1)
    end
  end
end
