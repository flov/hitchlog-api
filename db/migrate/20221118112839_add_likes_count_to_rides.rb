class AddLikesCountToRides < ActiveRecord::Migration[7.0]
  def change
    add_column :rides, :likes_count, :integer
  end
end
