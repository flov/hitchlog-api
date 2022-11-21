require "rails_helper"

RSpec.describe Like, type: :model do
  let(:like) { FactoryBot.build(:like) }

  describe "#valid?" do
    describe "#user_id" do
      it "is invalid without user_id" do
        like.user = nil
        expect(like).to_not be_valid
      end
    end

    describe "#trip_id" do
      it "is invalid without trip_id" do
        like.ride = nil
        expect(like).to_not be_valid
      end
    end

    describe "uniqueness of user_id for trip" do
      it "is invalid if user_id is not unique for trip_id" do
        like.save
        like2 = FactoryBot.build(:like, user_id: like.user_id, ride_id: like.ride_id)
        expect(like2).to_not be_valid
      end
    end
  end
end
