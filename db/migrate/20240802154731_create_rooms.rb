class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :address
      t.integer :price
      t.timestamps
    end
  end
end
