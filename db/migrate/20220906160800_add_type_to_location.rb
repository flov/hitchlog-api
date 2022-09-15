class AddTypeToLocation < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :type_of, :string
  end
end
