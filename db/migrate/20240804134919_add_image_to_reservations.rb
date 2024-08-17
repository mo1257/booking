class AddImageToReservations < ActiveRecord::Migration[6.1]
  def change
    add_column :reservations, :image, :string
  end
end
