class AddTypeToLocation2 < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :type, :string
  end
end
