class CreatePosts < ActiveRecord::Migration[7.0]
  def up
    begin
      drop_table :posts
    rescue ActiveRecord::StatementInvalid
      puts "table posts does not exist, creating it"
    end
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :tags, array: true
      t.belongs_to :user, null: false, foreign_key: true
      t.timestamps
    end
  end

  def down
    drop_table :posts
  end
end
