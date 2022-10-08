require "rails_helper"

RSpec.describe "/rides", type: :request do
  let(:valid_attributes) {
    {
      ride: {
        id:7321,
        vehicle:"bus",
        waiting_time:"13",
        story:"Took the Bemo out of town, which cost me 5000 rs, so not really a real hitchhike",
        title:"Hello ",
        experience:"very good"
      }
    }
  }
  let(:user) { create(:user) }
  let(:trip) { create(:trip, user: user) }
  let(:ride) { create(:ride, trip: trip) }
  let(:headers) {
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
  }
  let(:auth_headers) { JWTHelpers.auth_headers(headers, user) }

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
      create :ride
      get rides_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {experience: 'bad'}
      }

      it "updates the requested ride" do
        patch ride_url(ride),
          params: {ride: new_attributes}, headers: auth_headers, as: :json
        ride.reload
        expect(ride.experience).to eq('bad')
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
        ride = create(:ride)
        patch ride_url(ride),
          params: {ride: invalid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested ride" do
      ride
      expect {
        delete ride_url(ride), headers: auth_headers, as: :json
      }.to change(Ride, :count).by(-1)
    end
  end
end
