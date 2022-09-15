class AddFromNameToTrip < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :from_name, :string
    add_column :trips, :to_name, :string
  end
end
