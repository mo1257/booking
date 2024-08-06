class AddConfirmedToReservations < ActiveRecord::Migration[6.1]
  def change
    add_column :reservations, :confirmed, :boolean, default: false, null: false
  end
end
