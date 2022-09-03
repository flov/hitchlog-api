class AddPlaceIdToLocation < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :place_id, :string
  end
end
