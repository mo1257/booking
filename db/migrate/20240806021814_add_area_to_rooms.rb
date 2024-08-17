class AddAreaToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :area, :string
  end
end
