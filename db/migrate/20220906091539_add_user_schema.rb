class AddUserSchema < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :gender, :string
    add_column :users, :lat, :float
    add_column :users, :lng, :float
    add_column :users, :about_you, :text
    add_column :users, :cs_user, :string
    add_column :users, :city, :string
    add_column :users, :country_code, :string
    add_column :users, :country, :string
    add_column :users, :location, :string
    add_column :users, :languages, :string
    add_column :users, :origin, :string
    add_column :users, :be_welcome_user, :string
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :name, :string
    add_column :users, :trustroots, :string
    add_column :users, :date_of_birth, :date
  end
end
