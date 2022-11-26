require "rails_helper"

RSpec.describe "Statistics", type: :request do
  describe "GET /top_10" do
    it "returns http success" do
      11.times do |i|
        create(:user, gender: "male", username: "user#{i}", trips: [
          create(:trip, distance: 1000 * i)
        ])
      end
      get "/statistics/top_10", as: :json
      expect(response.body).to include("male")
    end
  end

  describe "GET /age_for_trips" do
    it "returns http success" do
      get "/statistics/age_for_trips", as: :json
      expect(response).to have_http_status(:success)
    end
  end
end
