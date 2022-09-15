class AddFromPlaceIdToTrip < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :from_place_id, :string
    add_column :trips, :to_place_id, :string
  end
end
