require "rails_helper"

RSpec.describe Trip, type: :model do
  let(:trip) { FactoryBot.build(:trip) }

  describe "#valid?" do
    it { is_expected.to validate_presence_of(:from) }
    it { is_expected.to validate_presence_of(:to) }
    it { is_expected.to validate_presence_of(:departure) }
    it { is_expected.to validate_presence_of(:arrival) }
    it { is_expected.to validate_presence_of(:travelling_with) }

    describe "#no_of_rides" do
      it "creates 1 ride on trip if no_of_rides equals 1" do
        user = FactoryBot.create(:user)
        trip = FactoryBot.create(:trip, no_of_rides: 1, user_id: user.id)
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

  describe "#overall_experience" do
    context "has only good experiences" do
      it "returns a good experience" do
        trip.rides << FactoryBot.create(:ride, experience: "good")
        expect(trip.overall_experience).to eq("good")
      end
    end

    context "has a neutral experience" do
      it "returns a neutral experience" do
        trip.rides << FactoryBot.build_stubbed(:ride, experience: "good")
        trip.rides << FactoryBot.build_stubbed(:ride, experience: "neutral")
        expect(trip.overall_experience).to eq("neutral")
      end
    end

    context "has a bad experience" do
      it "returns a bad experience" do
        trip.rides << FactoryBot.build(:ride, experience: "good")
        trip.rides << FactoryBot.build(:ride, experience: "neutral")
        trip.rides << FactoryBot.build(:ride, experience: "bad")
        expect(trip.overall_experience).to eq("bad")
      end
    end

    context "has a bad and a very good experience" do
      it "returns a bad experience" do
        trip.rides << FactoryBot.build(:ride, experience: "very good")
        trip.rides << FactoryBot.build(:ride, experience: "bad")
        expect(trip.overall_experience).to eq("bad")
      end
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
      expect(trip.average_speed).to eq("5 kmh")
    end
  end

  describe "countries=" do
    it "converts the string to an array and sets the country distances" do
      trip.countries = '[["Netherlands",116566],["Belgium",86072]]'
      expect(trip.country_distances.size).to eq(2)
      expect(trip.country_distances.first.distance).to eq(116566)
      expect(trip.country_distances.last.distance).to eq(86072)
    end
  end
end
