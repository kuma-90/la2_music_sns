class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.text :img
      t.timestamps null: false
    end
  end
end
