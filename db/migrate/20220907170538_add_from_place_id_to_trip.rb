class AddFromPlaceIdToTrip < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :from_place_id, :string
    add_column :trips, :to_place_id, :string
    add_column :trips, :from_name, :string
    add_column :trips, :to_name, :string
    add_index :trips, :from_lat
    add_index :trips, :from_lng
  end
end
