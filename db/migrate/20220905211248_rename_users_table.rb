class RenameUsersTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :users, :old_users
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.timestamps
    end
  end
end
