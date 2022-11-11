class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :mailer
      t.string :mailer_method
      t.string :from
      t.string :to
      t.string :subject
      t.text :body
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
