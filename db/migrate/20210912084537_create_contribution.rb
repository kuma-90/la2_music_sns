class CreateContribution < ActiveRecord::Migration[6.1]
  def change
     create_table :contributions do |t|
      t.string :artist_name
      t.text :comments
      t.text :user_name
      t.string :url
      t.text :jacket
      t.text :song
      t.text :album
  
      t.timestamps null: false
    end
  end
end
