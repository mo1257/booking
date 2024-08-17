class AddConfirmationDateToReservations < ActiveRecord::Migration[6.1]
  def change
    add_column :reservations, :confirmation_date, :datetime
  end
end
