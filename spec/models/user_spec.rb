require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  describe "valid?" do
    describe "#username" do
      it 'allows all these letters: /A-Za-z\d_-/' do
        user.username = "Abc1239_"
        expect(user).to be_valid
      end
    end
  end

  describe "#md5_email" do
    it "returns the md5 hash of the email" do
      user.email = "flo@hitchlog.com"
      expect(user.md5_email).to eq("b06f0acce61bb3ff40be64ae529c3384")
    end
  end

  describe "gender" do
    before { user.trips << FactoryBot.build(:trip) }
    it "should display percentage of genders of people who picked you up" do
      user.trips[0].rides << FactoryBot.build(:ride, gender: "male")
      user.trips[0].rides << FactoryBot.build(:ride, gender: "female")
      user.trips[0].rides << FactoryBot.build(:ride, gender: "mixed")
      user.save
      user.genders do
        it { is_expected.to include("male") }
        it { is_expected.to include("female") }
        it { is_expected.to include("mixed") }
      end
      user.genders_in_percentage do
        it { is_expected.to include({"male" => 0.33}) }
        it { is_expected.to include({"female" => 0.33}) }
        it { is_expected.to include({"mixed" => 0.33}) }
      end
    end

    it "only male driver" do
      user.trips[0].rides << FactoryBot.build(:ride, gender: "male")
      user.save
      expect(user.genders_in_percentage).to eq({"male" => 1.0})
    end
  end

  describe "#to_geomap" do
    before do
      user.trips << FactoryBot.build(:trip, from_city: "Berlin")
      user.trips << FactoryBot.build(:trip, from_city: "Madrid")
      2.times { user.trips.first.country_distances.build(country: "Germany", distance: 1000) }
      user.trips.last.country_distances.build(country: "Spain", distance: 1000)
    end

    it "should return the json for a google chart DataTable" do
      expect(user.to_geomap).to eq({
        "distances" => {
          "DE" => 2, "ES" => 1
        },
        "trip_count" => {"DE" => 2, "ES" => 1}
      })
    end
  end
end
