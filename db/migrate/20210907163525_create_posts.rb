class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user
      t.string :comment
      t.string :url
      t.string :artist_name
      t.string :photo
      t.string :name
      t.string :album_name
    end
  end
end
