class CreateReservations < ActiveRecord::Migration[6.1]
  def change
          create_table :reservations do |t|
            t.date :check_in
            t.date :check_out
            t.integer :people
            t.integer :count_day
            t.integer :sum_price
            t.integer :user_id
            t.integer :room_id
      t.timestamps
    end
  end
end
