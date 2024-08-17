class AddInfoToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :info, :text
  end
end
