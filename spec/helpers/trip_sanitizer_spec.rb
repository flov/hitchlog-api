require "rails_helper"

describe TripSanitizer do
  describe "#sanitize" do
    let(:trip) { FactoryBot.create(:trip) }

    context "from_lat and to_lat is empty" do
      it "updates missing geocode information" do
        allow(Geocoder).to receive(:search).with("Kabul")
          .and_return([OpenStruct.new(
            latitude: 34.5260109,
            longitude: 69.1776838
          )])
        allow(Geocoder).to receive(:search).with("Kiew")
          .and_return([OpenStruct.new(
            latitude: 50.4500336,
            longitude: 30.5241361
          )])
        trip.from_lng = nil
        trip.from_lat = nil
        trip.to_lng = nil
        trip.to_lat = nil
        trip.from_city = "Kabul"
        trip.to_city = "Kiew"
        described_class.new(trip).sanitize
        expect(trip.from_coordinates).to eq("34.5260109,69.1776838")
        expect(trip.to_coordinates).to eq("50.4500336,30.5241361")
      end
    end
  end
end
