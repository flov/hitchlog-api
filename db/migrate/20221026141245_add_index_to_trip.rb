class AddIndexToTrip < ActiveRecord::Migration[7.0]
  def change
    add_index :trips, :user_id
  end
end
