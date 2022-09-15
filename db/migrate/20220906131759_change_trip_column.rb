class ChangeTripColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :trips, :gmaps_duration, :google_duration
  end
end
