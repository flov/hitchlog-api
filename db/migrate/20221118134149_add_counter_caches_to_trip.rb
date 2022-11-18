class AddCounterCachesToTrip < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :rides_count, :integer
    add_column :trips, :comments_count, :integer
  end
end
