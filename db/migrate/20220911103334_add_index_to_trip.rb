class AddIndexToTrip < ActiveRecord::Migration[7.0]
  def change
    add_index :trips, :from_lat
    add_index :trips, :from_lng
  end
end
