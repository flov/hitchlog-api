class RemoveDeviseLogicTwo < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :password_salt
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :remember_token
    remove_column :users, :remember_created_at
  end
end
