class AddOriginAndDestinationToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :origin_id, :integer
    add_column :trips, :destination_id, :integer
  end
end
