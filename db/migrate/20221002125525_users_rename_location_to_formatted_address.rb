class UsersRenameLocationToFormattedAddress < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :location, :formatted_address
  end
end
