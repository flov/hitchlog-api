# frozen_string_literal: true

class DeviseCreateNewUsers < ActiveRecord::Migration[7.0]
  def change
    # drop_table :users
    # create_table :users do |t|
    # ## Database authenticatable
    # t.string :email, null: false, default: ""
    # t.string :encrypted_password, null: false, default: ""

    # ## Recoverable
    # t.string :reset_password_token
    # t.datetime :reset_password_sent_at

    # ## Rememberable
    # t.datetime :remember_created_at

    # ## Confirmable
    # t.string :confirmation_token
    # t.datetime :confirmed_at
    # t.datetime :confirmation_sent_at

    # t.string :username
    # t.string :gender
    # t.float :lat
    # t.float :lng
    # t.text :about_you
    # t.string :cs_user
    # t.string :city
    # t.string :country_code
    # t.string :country
    # t.string :location
    # t.string :languages
    # t.string :origin
    # t.string :be_welcome_user
    # t.string :uid
    # t.string :provider
    # t.string :name
    # t.string :trustroots
    # t.date :date_of_birth

    # t.timestamps null: false
    # end

    # add_index :users, :email, unique: true
    # add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token, unique: true
  end
end
