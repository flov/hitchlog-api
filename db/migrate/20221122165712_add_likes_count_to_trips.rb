class AddLikesCountToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :likes_count, :integer, default: 0
    add_index :trips, :likes_count
  end
end
