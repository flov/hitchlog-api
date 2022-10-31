class ChangePostTagsToString < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :tags, :string
    rename_column :posts, :tags, :tag
  end
end
