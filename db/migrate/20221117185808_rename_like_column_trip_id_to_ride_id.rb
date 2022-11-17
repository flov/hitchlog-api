class RenameLikeColumnTripIdToRideId < ActiveRecord::Migration[7.0]
  def change
    remove_column :likes, :trip_id
    add_column :likes, :ride_id, :bigint, foreign_key: true
    add_index :likes, :ride_id
    add_foreign_key "likes", "rides"
  end
end
