class AddSeatIdToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :seat_id, :integer
  end
end
