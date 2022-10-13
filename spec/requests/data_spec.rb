require "rails_helper"

RSpec.describe "Data", type: :request do
  describe "GET /country_map" do
    it "renders a successful response" do
      get data_country_map_url
      expect(response).to be_successful
    end
  end
  describe "GET /trips_count" do
    it "renders a successful response" do
      get data_trips_count_url
      expect(response).to be_successful
    end
  end
  describe "GET /written_stories" do
    it "renders a successful response" do
      get data_written_stories_url
      expect(response).to be_successful
    end
  end
end
