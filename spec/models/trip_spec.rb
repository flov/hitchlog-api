require "rails_helper"

RSpec.describe Trip, type: :model do
  let(:trip) { FactoryBot.build(:trip) }

  describe "#to_param" do
    before do
      allow(trip).to receive(:id).and_return(123)
    end

    context "has attribute from_city and to_city" do
      it "should output correctly" do
        trip.from_city = "Cologne"
        trip.to_city = "Berlin"
        expect(trip.to_param).to eq("hitchhiking-trip-from-cologne-to-berlin-123")
      end
    end

    context "has attribute from_name and to_name, but not from_city and to_city" do
      it "should output correctly" do
        trip.from_city = ""
        trip.to_city = ""
        trip.from_name = "tenerife airport"
        trip.to_name = "los christianos puerto"
        expect(trip.to_param).to eq("hitchhiking-trip-from-tenerife-airport-to-los-christianos-puerto-123")
      end
    end

    context "no name and no city, but formatted_address" do
      it "returns the right to_param" do
        trip.from_city = ""
        trip.to_city = ""
        trip.from_name = ""
        trip.to_name = ""
        trip.from_formatted_address = "Muelle de Pescadores, puerto de Los Cristianos., 38650 Arona, Santa Cruz de Tenerife, Spain"
        trip.to_formatted_address = "38610, Santa Cruz de Tenerife, Spain"
        expect(trip.to_param).to eq("hitchhiking-trip-from-muelle-de-pescadores-2c-puerto-de-los-cristianos-2c-38650-arona-2c-santa-cruz-de-tenerife-2c-spain-to-38610-2c-santa-cruz-de-tenerife-2c-spain-123")
      end
    end
  end

  describe "#valid?" do
    describe "#number_of_rides" do
      it "creates 1 ride on trip if number_of_rides equals 1" do
        user = FactoryBot.create(:confirmed_user)
        trip = FactoryBot.create(:trip, number_of_rides: 1, user_id: user.id)
        expect(trip.rides.size).to eq(1)
      end
    end
  end

  describe "#kmh" do
    it "returns km/h" do
      trip.distance = 50_000 # 50 kms
      trip.departure = "07/12/2011 10:00"
      trip.arrival = "07/12/2011 13:00"
      expect(trip.kmh).to eq(16)
    end
  end

  describe "#duration" do
    it "should reckon duration with arrival - departure" do
      expect(trip.duration).to eq(trip.arrival - trip.departure)
    end
  end

  describe "#total_waiting_time" do
    it "returns the total accumulated waiting_time" do
      trip.rides << FactoryBot.build(:ride, waiting_time: 5)
      trip.rides << FactoryBot.build(:ride, waiting_time: 6)
      expect(trip.total_waiting_time).to eq("11 minutes")
    end

    it "returns nil if no waiting time has been logged" do
      trip.rides << FactoryBot.build(:ride, waiting_time: nil)
      expect(trip.total_waiting_time).to eq(nil)
    end
  end

  describe "add_ride" do
    it "adds a ride to the trip" do
      trip.save
      expect(trip.rides.size).to eq(1)
      trip.add_ride
      expect(trip.rides.size).to eq(2)
    end
  end

  describe "#age_of_trip" do
    it "displays the age of the hitchhiker at the time the trip was done" do
      trip.user.date_of_birth = 20.year.ago.to_date
      trip.departure = (1.year.ago - 200.days).to_datetime
      expect(trip.age_at_trip).to eq(18)
    end
  end

  describe "#average_speed" do
    it "returns the average speed" do
      trip.distance = 5000 # meters
      allow(trip).to receive_messages(duration: 1.hour.to_i)
      expect(trip.average_speed).to eq("5 km/h")
    end
  end
end
